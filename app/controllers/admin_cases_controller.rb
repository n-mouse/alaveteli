class AdminCasesController < AdminController

    layout "admin"

    def index
      @cases = Case.order('created_at DESC')
    end
    
    def new
      @case = Case.new
    end
    
    def show
      @case = Case.friendly.find(params[:id])
    end
    
    def create
      @case = Case.create(case_params)
      if @case.save
        redirect_to admin_case_path(@case)
      else
        render 'new'
      end
    end
    
    def edit
      @case = Case.friendly.find(params[:id])
    end
    
    def update
      @case = Case.friendly.find(params[:id])
      if @case.update_attributes(case_params)
        redirect_to admin_case_path(@case)
      else
        render 'edit'
      end
    end
    
    def destroy
      @case = Case.friendly.find(params[:id])
      @case.destroy
      redirect_to admin_cases_path
    end
    
    private

 
  def case_params
    params.require(:case).permit(:body, :title, :image, :published, :remove_image)
  end

end
