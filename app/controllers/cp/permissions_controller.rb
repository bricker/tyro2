class Cp::PermissionsController < Cp::BaseController
  before_filter :check_if_can_admin # admins only in here
  before_filter :get_permission, :only => [:edit, :update]
  before_filter :get_living_users, :only => [:edit, :update]
  
  respond_to :html
  
  def index
    respond_with(@permissions = Permission.includes(:users).all)
  end
  
  def edit
    respond_with @permission
  end
  
  def update
    params[:permission][:user_ids] ||= []
    flash[:notice] = "Updated Permission." if @permission.update_attributes(params[:permission])
    respond_with @permission
  end

  def update_all_permissions
    params[:permission].keys.each do |id|
      @permission = Permission.find(id)
      @permission.update_attributes(params[:permission][id])
    end
    
    flash[:notice] = "Updated Grid."
    respond_with @permission
  end
  
  private
    def check_if_can_admin
      return true if @current_user.allowed_to('admin')
      redirect_to cp_root_path and return false
    end
    
    def get_permission
      @permission = Permission.includes(:users).find(params[:id]) 
    end
    
    def get_users
      @users = User.all
    end
end
