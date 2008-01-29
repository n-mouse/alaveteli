# app/controllers/request_controller.rb:
# Show information about one particular request.
#
# Copyright (c) 2007 UK Citizens Online Democracy. All rights reserved.
# Email: francis@mysociety.org; WWW: http://www.mysociety.org/
#
# $Id: request_controller.rb,v 1.42 2008-01-29 03:05:46 francis Exp $

class RequestController < ApplicationController
    
    def show
        @info_request = InfoRequest.find(params[:id])
        @correspondences = @info_request.incoming_messages + @info_request.info_request_events
        @correspondences.sort! { |a,b| a.sent_at <=> b.sent_at } 
        @status = @info_request.calculate_status
        @date_response_required_by = @info_request.date_response_required_by
        @collapse_quotes = params[:unfold] ? false : true
        @is_owning_user = !authenticated_user.nil? && authenticated_user.id == @info_request.user_id
        @needing_description = @info_request.incoming_messages_needing_description
    end

    def list
        @info_requests = InfoRequest.paginate :order => "created_at desc", :page => params[:page], :per_page => 25
    end
    
    def frontpage
    end

    # Page new form posts to
    def new
        # First time we get to the page, just display it
        if params[:submitted_new_request].nil?
            # Read parameters in - public body can be passed from front page
            @info_request = InfoRequest.new(params[:info_request])
            @outgoing_message = OutgoingMessage.new(params[:outgoing_message])
            render :action => 'new'
            return
        end

        # See if the exact same request has already been submitted
        # XXX this *should* also check outgoing message joined to is an initial request (rather than follow up)
        # XXX this check could go in the model, except we really want to pass @existing_request to the view so it can link to it.
        # XXX could have a date range here, so say only check last month's worth of new requests. If somebody is making
        # repeated requests, say once a quarter for time information, then might need to do that.
        @existing_request = InfoRequest.find(:first, :conditions => [ 'title = ? and public_body_id = ? and outgoing_messages.body = ?', params[:info_request][:title], params[:info_request][:public_body_id], params[:outgoing_message][:body] ], :include => [ :outgoing_messages ] )

        # Create both FOI request and the first request message
        @info_request = InfoRequest.new(params[:info_request])
        @outgoing_message = OutgoingMessage.new(params[:outgoing_message].merge({ 
            :status => 'ready', 
            :message_type => 'initial_request'
        }))
        @info_request.outgoing_messages << @outgoing_message
        @outgoing_message.info_request = @info_request

        # See if values were valid or not
        if !@existing_request.nil? || !@info_request.valid?
            # We don't want the error "Outgoing messages is invalid", as the outgoing message
            # will be valid for a specific reason which we are displaying anyway.
            @info_request.errors.delete("outgoing_messages")
            render :action => 'new'
        elsif authenticated?(
                :web => "To send your FOI request",
                :email => "Then your FOI request to " + @info_request.public_body.name + " will be sent.",
                :email_subject => "Confirm your FOI request to " + @info_request.public_body.name
            )
            @info_request.user = authenticated_user
            # This automatically saves dependent objects, such as @outgoing_message, in the same transaction
            @info_request.save!
            # XXX send_message needs the database id, so we send after saving, which isn't ideal if the request broke here.
            @outgoing_message.send_message
            flash[:notice] = "Your Freedom of Information request has been created and sent on its way."
            redirect_to show_request_url(:id => @info_request)
        else
            # do nothing - as "authenticated?" has done the redirect to signin page for us
        end
    end

    # Page describing state of message posts to
    def describe_state
        @info_request = InfoRequest.find(params[:id])
        @needing_description = @info_request.incoming_messages_needing_description
        @is_owning_user = !authenticated_user.nil? && authenticated_user.id == @info_request.user_id

        if not @info_request.awaiting_description
            flash[:notice] = "The status of this request is up to date."
            if !params[:submitted_describe_state].nil?
                flash[:notice] = "The status of this request was made up to date elsewhere while you were filling in the form."
            end
            redirect_to show_request_url(:id => @info_request)
            return
        end

        if !params[:submitted_describe_state].nil?
            if not authenticated_as_user?(@info_request.user,
                    :web => "To classify the response to this FOI request",
                    :email => "Then you can classify the FOI response you have got from " + @info_request.public_body.name + ".",
                    :email_subject => "Classify an FOI response from " + @info_request.public_body.name
                )
                # do nothing - as "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:incoming_message]
                flash[:error] = "Please choose whether or not you got some of the information that you wanted."
                return
            end

            @info_request.awaiting_description = false
            @info_request.described_last_incoming_message_id = @needing_description[-1].id # XXX lock this with InfoRequest.receive
            @info_request.described_state = params[:incoming_message][:described_state]
            @info_request.save!
            if @info_request.described_state == 'waiting_response'
                flash[:notice] = "<p>Thank you! Hopefully your wait isn't too long.</p> <p>By law, you should get a response before the end of <strong>" + simple_date(@info_request.date_response_required_by) + "</strong>.</p>"
                redirect_to show_request_url(:id => @info_request)
            elsif @info_request.described_state == 'rejected'
                # XXX explain how to complain
                flash[:notice] = "Oh no! Sorry to hear that your request was rejected. Here is what to do now."
                redirect_to unhappy_url
            elsif @info_request.described_state == 'successful'
                flash[:notice] = "We're glad you got all the information that you wanted. Thank you for using GovernmentSpy."
                # XXX quiz them here for a comment
                redirect_to show_request_url(:id => @info_request)
            elsif @info_request.described_state == 'partially_successful'
                flash[:notice] = "We're glad you got some of the information that you wanted."
                # XXX explain how to complain / quiz them for a comment
                redirect_to show_request_url(:id => @info_request)
            elsif @info_request.described_state == 'waiting_clarification'
                flash[:notice] = "Please write your follow up message containing the necessary clarifications below."
                redirect_to show_response_url(:id => @info_request.id, :incoming_message_id => @needing_description[-1].id)
            else
                raise "unknown described_state " + @info_request.described_state
            end
            return
        end
    end


    # Show an individual incoming message, and allow followup
    def show_response
        @incoming_message = IncomingMessage.find(params[:incoming_message_id])
        @info_request = @incoming_message.info_request
        @collapse_quotes = params[:unfold] ? false : true
        @is_owning_user = !authenticated_user.nil? && authenticated_user.id == @info_request.user_id

        params_outgoing_message = params[:outgoing_message]
        if params_outgoing_message.nil?
            params_outgoing_message = {}
        end
        params_outgoing_message.merge!({ 
            :status => 'ready', 
            :message_type => 'followup',
            :incoming_message_followup => @incoming_message
        })
        @outgoing_message = OutgoingMessage.new(params_outgoing_message)

        if @incoming_message.info_request_id != params[:id].to_i
            raise sprintf("Incoming message %d does not belong to request %d", @incoming_message.info_request_id, params[:id])
        end

        if !params[:submitted_followup].nil?
            # See if values were valid or not
            @outgoing_message.info_request = @info_request
            if !@outgoing_message.valid?
                render :action => 'show_response'
            elsif authenticated_as_user?(@info_request.user,
                    :web => "To send a follow up message about your FOI request",
                    :email => "Then you can send a follow up message to " + @info_request.public_body.name + ".",
                    :email_subject => "Confirm your FOI follow up message to " + @info_request.public_body.name
                )
                # Send a follow up message
                @outgoing_message.send_message
                @outgoing_message.save!
                flash[:notice] = "Your follow up message has been created and sent on its way."
                redirect_to show_request_url(:id => @info_request)
            else
                # do nothing - as "authenticated?" has done the redirect to signin page for us
            end
        else
            # render default show_response template
        end
    end

    # Download an attachment
    def get_attachment
        @incoming_message = IncomingMessage.find(params[:incoming_message_id])
        @info_request = @incoming_message.info_request
        if @incoming_message.info_request_id != params[:id].to_i
            raise sprintf("Incoming message %d does not belong to request %d", @incoming_message.info_request_id, params[:id])
        end
        @part_number = params[:part].to_i
        
        @attachment = IncomingMessage.get_attachment_by_url_part_number(@incoming_message.get_attachments_for_display, @part_number)
        response.content_type = 'application/octet-stream'
        if !@attachment.content_type.nil?
            response.content_type = @attachment.content_type
        end
        render :text => @attachment.body
    end

    private
end
