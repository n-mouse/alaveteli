class SandboxController < ApplicationController 

  def nasud
    @cases = Case.where("created_at < ?", Time.now).order('created_at DESC')
    render :layout => "nasud"
  end
  
  def domiki
    render :layout => "blank"
  end
  
  def covid
    render :layout => "blank"
  end
  
end
