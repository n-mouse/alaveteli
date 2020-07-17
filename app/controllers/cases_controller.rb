class CasesController < ApplicationController
  
  def show
    @case = Case.friendly.published.find(params[:id])
    render :layout => "nasud"
  end
  
end
