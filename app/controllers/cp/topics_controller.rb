class Cp::TopicsController < Cp::BaseController
  before_filter :get_forum, :only => [:index, :new, :create]
  before_filter :get_topic, :only => [:edit, :update, :destroy]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  before_filter :get_unread, :only => [:index, :unread]
  
  respond_to :html
  
  def index
    respond_with @topics = @forum.topics.page(params[:page]).with_stickies
  end
  
  def unread
    respond_with @topics = @unread_topics.page(params[:page]).with_stickies
  end
  
  def mark_read
    Topic.mark_as_read! :all, :for => current_user
    redirect_to unread_cp_topics_path, :notice => "Marked all topics as Read."
  end
  
  
  def new
    @topic = Topic.new
    @topic.build_initial_message
  end
  
  def create
    params[:topic][:initial_message_attributes].merge!(:user_id => @current_user.id)
    @topic = Topic.new(params[:topic].merge!(:forum_id => @forum.id))
    flash[:notice] = "Topic started." if @topic.save
    respond_with :cp, @topic, :messages
  end
  
  
  def edit
  end
  
  def update
    flash[:notice] = "Updated topic." if @topic.update_attributes(params[:topic])
    respond_with :cp, @topic, :messages
  end
  
  
  def destroy
    if @topic.destroy
      flash[:notice] = "Deleted topic."
    else
      flash[:alert] = "Topic could not be deleted. Try again."
    end
    respond_with :cp, @topic.forum, :topics
  end
  
  private
    def get_forum
      @forum = Forum.find(params[:forum_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Forum not found."
        redirect_to cp_forums_path
    end
    
    def get_topic
      @topic = Topic.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Topic not found."
        redirect_to cp_forums_path
    end
    
    def check_permissions
      return true if @current_user.allowed_to('admin') or @topic.user == @current_user
      redirect_to cp_topic_messages_path(@topic) and return false
    end
    
    def get_unread
      @unread_topics = Topic.unread_by(@current_user)
    end
end
