class Cp::ForumsController < Cp::BaseController
  before_filter :get_forum, :only => [:edit, :update, :destroy]
  before_filter :check_permissions, :except => :index
  
  respond_to :html
  
  def index
    @unread_topics = Topic.unread_by(@current_user)
    respond_with @forums = Forum.all
  end
  
  def new
    respond_with @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(params[:forum])
    flash[:notice] = "Forum created." if @forum.save
    respond_with :cp, @forum, :location => cp_forums_path
  end
  
  
  def edit
  end
  
  def update
    flash[:notice] = "Updated forum." if @forum.update_attributes(params[:forum])
    respond_with :cp, @forum, :location => cp_forums_path
  end
  
  
  def destroy
    if @forum.destroy
      flash[:notice] = "Deleted forum."
    else
      flash[:alert] = "Forum could not be deleted. Try again."
    end
    respond_with :cp, @forum
  end
  
  private
  
    def get_forum
      @forum = Forum.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Forum not found."
        redirect_to cp_forums_path
    end
    
    def check_permissions
      return true if @current_user.allowed_to('admin')
      redirect_to cp_forums_path and return false
    end
end
