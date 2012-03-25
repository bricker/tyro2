class Cp::ProfilesController < Cp::BaseController
  before_filter :get_user
  
  respond_to :html
  
  def show
    render 'cp/users/show'
  end
  
  def strikes
    @strikes = @current_user.strikes.unresolved
    respond_with @user
  end
  
  def training_progress
    unless @user.roles.exists?(:title => 'noob')
      flash[:alert] = "You aren't training."
      redirect_to cp_profile_path and return false
    end
    @training_steps = TrainingStep.all
    respond_with @user
  end
  
  
  def edit
    respond_with @user
  end
  
  def update
    flash[:notice] = "Updated profile" if @current_user.update_attributes(params[:user])
    respond_with :user, :location => cp_profile_path
  end
  
  
  def edit_password
    respond_with @user
  end
  
  def update_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
   if @user.save
     flash[:notice] = "Password Changed"
     respond_with :cp, @user, :location => cp_profile_path
   else
     render :edit_password
   end
  end
  
  private
    def get_user
      @user = @current_user
    end
end
