class Cp::StrikesController < Cp::BaseController
  before_filter :get_user
  before_filter :check_if_can_view_strikes
  before_filter :check_if_can_manage_strikes, :only => [:new, :edit, :create, :toggle_resolved, :update, :delete]
  before_filter :get_strike, :only => [:edit, :update, :toggle_resolved, :destroy]

  respond_to :html
  
  # TODO: Schedule review board? Check with MG's if this is needed and used anymore.
  
  def index
    if params[:list] == 'resolved'
      @strikes = @user.strikes.resolved
    else
      @strikes = @user.strikes.unresolved
    end
    
    respond_with @strikes
  end
  

  def new
    @strike = @user.strikes.build
  end
  
  def create # TODO: clean this action up a bit.
    @strike = @user.strikes.build(params[:strike].merge!(:striker_id => @current_user.id))
    if @strike.save
      flash[:notice] = "Added Strike."
      if params[:comment].present?
        @comment = @user.comments.build(params[:comment].merge!(:commenter_id => @current_user.id))
        flash[:notice] += " Also Added comment to #{@user.name}'s Performance Report." if @comment.save
      end
    end
    respond_with :cp, @strike, :location => cp_user_strikes_path(@user)
  end
  
  
  def edit
    respond_with @strike
  end
  
  def update
    flash[:notice] = "Updated Strike" if @strike.update_attributes(params[:strike])
    respond_with @strike, :location => cp_user_strikes_path(@user)
  end
  
  def toggle_resolved
    if @strike.update_attribute('resolved', !@strike.resolved)
      flash[:notice] = "Changed Status of strike"
    else
      flash[:alert] = "Could not change status of strike"
    end
    respond_with @strike, :location => cp_user_strikes_path(@user)
  end
  
  
  def destroy
    if @strike.delete
      @strike.update_strikes
      flash[:notice] = "Deleted Strike"
    else
      flash[:alert] = "Could not delete strike"
    end
    respond_with @strike, :location => cp_user_strikes_path(@user)
  end
  
  private
    def get_user
      @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "User not found."
        redirect_to cp_root_path
    end
    
    def check_if_can_view_strikes
      return true if @current_user.allowed_to('manage_strikes') or @current_user == @user
      redirect_to cp_root_path and return false
    end
    
    def check_if_can_manage_strikes
      return true if @current_user.allowed_to('manage_strikes')
      redirect_to cp_root_path and return false
    end
    
    def get_strike
      @strike = Strike.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Strike not found."
        redirect_to cp_root_path
    end
end
