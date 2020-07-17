class TinymceAssetsController < ApplicationController

  def create
    image = Image.create tiny_params.slice(:file, :alt, :hint)

    render json: {
      image: {
        url:    image.file.url,
      }
    }, layout: false, content_type: "text/html"
  end
  
  def tiny_params
    params.permit(:file, :alt, :hint)
  end
  
  
end
