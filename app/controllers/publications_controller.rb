class PublicationsController < ApplicationController

  def show
    @publication = Publication.find(params[:id])
  end
  
  def index
    @publications = Publication.published.order('created_at DESC').paginate(:page => params[:page], :per_page => 14)
       #@grouped_publications = @publications.in_groups(2)
       #@publicationsl = @grouped_publications[0]
       #@publicationsr = @grouped_publications[1]
        @publicationsl = []
        @publicationsr = []
        @publications.each_with_index do |p, i|
         if i.odd?
          @publicationsr << p
        else
         @publicationsl << p
        end
        end
  end
  
  def stories
    @publications = Publication.published.stories.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
       render "index" 
  end
  
  def videos 
    @publications = Publication.published.videos.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
    render "index"
  end
  
  def news
    @publications = Publication.published.news.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
    render "index"
  end
  
  def blogs 
    @publications = Publication.published.blogs.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
    render "index"
  end
  
  def digest
    @publications = Publication.published.digest.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
    render "index"
  end
  
end