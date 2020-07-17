class DonationsController < ApplicationController
  
  layout "nasud"

  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.create(donation_params)
    respond_to do |format|  
      if @donation.save
	    format.js 
      else  
        format.html { render :action => "new" }
      end
    end
  end
    
  def donation_params
    params.require(:donation).permit(:name, :activity, :sum, :phone, :email, :link)
  end
end
