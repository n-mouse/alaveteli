class ViolationsController < ApplicationController
  
  layout "nasud"

  def new
    @violation = Violation.new
  end

  def create
    @violation = Violation.create(violation_params)
    if @violation.save
      redirect_to nasud_path, :flash => { :success => "Дякуємо! Вашу заявку відправлено. Ми зв'яжемося з вами найближчим часом" }
    else  
      render :action => "new" 
    end
  end
    
  def violation_params
    params.require(:violation).permit(:name, :organization, :description, :phone, :email, :link, :req, :resp)
  end
end
