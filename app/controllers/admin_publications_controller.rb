class AdminPublicationsController < AdminController

    layout "admin"

    def index
      publications = Publication.where(nil).order('created_at DESC')
      publications = Publication.where(category: params[:category_id]).order('created_at DESC') if params[:category_id].present?
      publications = publications.where(published: false) if params[:published].present?
      @query = params[:query]
      if @query
           publications = publications.where(["lower(title) like lower('%'||?||'%')", @query])
      end
      @publications = publications.paginate :order => "created_at", :page => params[:page], :per_page => 30
    end
    
    def new
      @publication = Publication.new
    end
    
    def show
      @publication = Publication.find(params[:id])
    end
    
    def create

      @publication = @user.publications.create(params[:publication])
      
      if @publication.save
      redirect_to admin_publication_path(@publication)
      else
        render 'new'
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
    
    def destroy
            @publication = Publication.find(params[:id])

        @publication.destroy
        redirect_to admin_publications_path
    end
    
    private


def filtering_params(params)
  params.slice(:category, :author)
end

end
