class Cp::TrainingStepsController < Cp::BaseController
  before_filter :check_permissions, :except => :index
  before_filter :get_training_step, :only => [:edit, :update, :destroy]
  
  respond_to :html
  
  def index
    respond_with @training_steps = TrainingStep.includes(:users)
  end
  
  
  def new
    respond_with @training_step = TrainingStep.new
  end
  
  def create
    @training_step = TrainingStep.new(params[:training_step])
    if @training_step.save
      redirect_to cp_training_steps_path, :notice => "Added Training Step."
    else
      render :new
    end
  end
  
  
  def edit
    respond_with @training_step
  end
  
  def update
    if @training_step.update_attributes(params[:training_step])
      redirect_to cp_training_steps_path, :notice => "Updated Training Step."
    else
      render :edit
    end
  end
  
  
  def destroy
    if @training_step.destroy
      flash[:notice] = "Removed Training Step"
    else
      flash[:alert] = "Could not remove Training Step"
    end
    respond_with [:cp, @training_step]
  end
  
  private
    def check_permissions
      return true if @current_user.allowed_to('manage_training_steps')
      redirect_to cp_users_path and return false
    end
    
    def get_training_step
      @training_step = TrainingStep.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Training Step not found"
        redirect_to cp_root_path
    end
end
