class AdminViolationsController < AdminController

  layout "admin"

  def index
    @violations = Violation.order('created_at DESC')
  end
    
  def show
    @violation = Violation.find(params[:id])
  end
  
  def destroy
    @violation = Violation.find(params[:id])
    @violation.destroy
    redirect_to admin_violations_path
  end
  
  def edit
    @violation = Violation.find(params[:id])
  end
    
  def update
    @violation = Violation.find(params[:id])
    if @violation.update_attributes(violation_params)
      redirect_to admin_violation_path(@violation)
    else
      render 'edit'
    end
  end

end
