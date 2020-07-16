class AdminPublicationsController < AdminController

    layout "admin"

    def index
      publications = Publication.where(nil).order('created_at DESC')
      publications = Publication.where(category_id: params[:category_id]).order('created_at DESC') if params[:category_id].present?
      publications = publications.where(published: false) if params[:published].present?
      @query = params[:query]
      if @query
           publications = publications.where(["lower(title) like lower('%'||?||'%')", @query])
      end
      @publications = publications.paginate(:page => params[:page], :per_page => 30).order('created_at')
    end
    
    def new
      
      @publication = Publication.new
      @publication.images.build
    end
    
    def show
      @publication = Publication.friendly.find(params[:id])
    end
    
    def create

      @publication = Publication.create(publication_params)
      
      if @publication.save
      if params[:files]
        params[:files].each do |file|
          @publication.images.create(file: file)
        end
      end
      redirect_to admin_publication_path(@publication)
      else
        render 'new'
      end
    end
    
    def edit
      @publication = Publication.friendly.find(params[:id])
    end
    
    def update
      @publication = Publication.friendly.find(params[:id])
      if @publication.update_attributes(publication_params)
        redirect_to admin_publication_path(@publication)
      else
        render 'edit'
      end
    end
    
    def destroy
        @publication = Publication.friendly.find(params[:id])

        @publication.destroy
        redirect_to admin_publications_path
    end
    
    private


  def filtering_params(params)
    params.slice(:category, :author)
  end
  
  def publication_params
    params.require(:publication).permit(:body, :summary, :title, :author, :category_id, :image, :published, :edchoice, :project, :created_at, :remove_image, images_attributes: [:file, :caption, :id, :_destroy])
  end

end
