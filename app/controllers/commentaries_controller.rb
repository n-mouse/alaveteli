class CommentariesController < ApplicationController

  before_action :legal_user, :except => [:index]
  
  def index
    @commentaries = Commentary.order('created_at DESC')
  end

  def new
    @commentary = Commentary.new
    @ir = InfoRequest.find(params[:ir_id]).id
  end
  
  def create
    @commentary = Commentary.new(commentary_params.merge({:user_id => @user.id, :info_request_id => params[:info_request_id]}))

    if @commentary.save
      @commentary.info_request.log_event("commentary", { :commentary_id => @commentary.id })
      flash[:notice] = "Коментар успішно додано"
      redirect_to show_request_url(@commentary.info_request.url_title)
    else
      flash[:error] = "Коментар не збережено"
      render 'commentaries/new'
    end
  end
  
  def edit
    @commentary = Commentary.find(params[:id])
    @ir = InfoRequest.find(params[:ir_id])
  end
  
  def update
    @commentary = Commentary.find(params[:id])
    if @commentary.update_attributes(commentary_params)
      @commentary.info_request.log_event("edit_commentary", { :commentary_id => @commentary.id })
      flash[:notice] = "Коментар відредаговано"
      redirect_to show_request_url(@commentary.info_request.url_title)      
    else
      flash[:error] = "Коментар не збережено"
      render 'commentaries/edit'
    end
  end
  
  def destroy
    @commentary = Commentary.find(params[:id])
    @info_request = @commentary.info_request
    @commentary.destroy
    flash[:notice] = "Коментар видалено"
    redirect_to show_request_url(@info_request.url_title) 
  end
  
  private
  
  def legal_user
    unless @user && @user.legal_comment?
      flash[:error] = "Ви не авторизовані або у вас недостатньо повноважень"
      redirect_to request_list_all_path
    end
  end  
  
  def commentary_params
    params.require(:commentary).permit(:subject, :content)
  end
  
end 
