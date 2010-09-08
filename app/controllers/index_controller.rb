class IndexController < ApplicationController
  def index
    if !logged_in?
      return render :template=>'auth/index',:layout=>'auth'
    end
  end

  def updating
   redirect_to '/updating.html',:status=>301
  end

  def dev
    render_ui do |ui|
      ui.fbox :show,:title=>'bucuo',:partial=>'index/dev'
    end
  end

end