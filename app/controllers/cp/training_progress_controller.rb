class Cp::TrainingProgressController < Cp::BaseController
  before_filter :get_user
  before_filter :check_if_noob
  before_filter :check_permissions, :only => [:edit, :update]
  before_filter :get_training_steps, :only => [:show, :edit]
  respond_to :html
  
  def show
    respond_with @user
  end
  
  def edit
    respond_with @user
  end
  
  def update
    params[:user][:training_step_ids] ||= []
    flash[:notice] = "Updated Training Progress" if @user.update_attributes(params[:user])
    respond_with :cp, @user, :training_progress
  end
  
  private
    def get_user
      @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "User Not Found"
        redirect_to cp_users_path
    end
    
    def check_if_noob
      return true if @user.roles.exists?(:title => 'noob')
      flash[:alert] = "This user isn't training."
      redirect_to cp_user_path(@user) and return false
    end
    
    def check_permissions
      return true if @current_user.allowed_to('train_users')
      redirect_to cp_user_training_steps_path(@user) and return false
    end
    
    def get_training_steps
      @training_steps = TrainingStep.all
    end
end
