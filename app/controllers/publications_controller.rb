class PublicationsController < ApplicationController

  def show
    @publication = Publication.find(params[:id])
  end
  
  def index
    @publications = Publication.published.order('created_at DESC').paginate(:page => params[:page], :per_page => 12)
  end
  
  def stories
    @stories = Publication.published.stories.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end
  
  def videos 
    @videos = Publication.published.videos.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end
  
  def news
    @news = Publication.published.news.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end
end
