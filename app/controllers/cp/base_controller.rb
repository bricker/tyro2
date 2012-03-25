class Cp::BaseController < ApplicationController
  before_filter :current_user, :login_required
  layout "cp"
  helper_method :current_user
  
  def login_required
  	return true if current_user
  	session[:return_to] = request.fullpath
  	redirect_to cp_login_path and return false
  end

  private
    def current_user
      @current_user ||= User.includes(:permissions).find(session[:user_id]) if session[:user_id]
    end
    
    def get_tags
      @tags = Tag.scoped
    end
end
