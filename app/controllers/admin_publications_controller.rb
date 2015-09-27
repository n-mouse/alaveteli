class AdminPublicationsController < AdminController

    layout "admin"


    def index
      @publications = Publication.all
    end
    
    def new
      
    end
    
    def show
      @publication = Publication.find(params[:id])
    end
    
    def create
      @publication = @user.publications.create(params[:publication])
      if @publication.save
      redirect_to admin_publication_path(@publication)
      else
        flash.now[:danger] = "error"
      end
    end
    
    def edit
      @publication = Publication.find(params[:id])
    end
    
    def update
      @publication = Publication.find(params[:id])
 
  if @publication.update_attributes(params[:publication])
    redirect_to admin_publication_path(@publication)
  else
    render 'edit'
  end
    end

end
