class AdminCommentariesController < AdminController

    layout "admin"

    def index
      @commentaries = Commentary.order('created_at DESC')
    end
    
end
