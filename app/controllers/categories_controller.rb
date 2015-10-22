class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @categories = Category.all
    @publications = @category.publications.published.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)

end
end
