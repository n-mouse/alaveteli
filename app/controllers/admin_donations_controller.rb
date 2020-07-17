class AdminDonationsController < AdminController

  layout "admin"

  def index
    @donations = Donation.order('created_at DESC')
  end
    
  def show
    @donation = Donation.find(params[:id])
  end
  
  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
    redirect_to admin_donations_path
  end

end
