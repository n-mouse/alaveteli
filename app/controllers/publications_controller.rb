class PublicationsController < ApplicationController
  
  def show
    @publication = Publication.friendly.published.find(params[:id])
    impressionist(@publication, "message", :unique => [:session_hash])
  end
  
  def feed
    @publications = Publication.published.where("created_at < ?", Time.now).order('created_at DESC')
    respond_to do |format|
      format.rss { render layout: false }
    end
  end 
  
  def index
    if params[:tag] == 'covid'
       @publications = Publication.published.where(project: "COVID19").where("created_at < ?", Time.now).order('created_at DESC').paginate(:page => params[:page], :per_page => 14)
       @intro = "Публікації на тему COVID19"
    else
      @publications = Publication.published.where("created_at < ?", Time.now).order('created_at DESC').paginate(:page => params[:page], :per_page => 14)
    end
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
  
  def covid
    @publications = Publication.published.where(project: "COVID19").where("created_at < ?", Time.now).order('created_at DESC')
  end
   
  def hto
    @articles = Publication.published.where(project: "Хто відповідає").where("created_at < ?", Time.now).order('created_at DESC')
    render layout: "blank"
  end
 
  
end
