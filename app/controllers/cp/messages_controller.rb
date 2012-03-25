class Cp::MessagesController < Cp::BaseController
  before_filter :get_topic, :only => [:index, :new, :create]
  before_filter :get_message, :only => [:edit, :update, :destroy]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  before_filter :check_if_locked, :only => [:new, :create, :edit, :update]
  
  respond_to :html
    
  def index
    @message = Message.new
    @unread_topics = Topic.unread_by(@current_user)
    @topic.mark_as_read!(:for => @current_user) if @unread_topics.include?(@topic)
    respond_with @messages = @topic.messages.page(params[:page])
  end  
  
  def new
    respond_with @message = Message.new
  end
  
  def create
    @message = Message.new(params[:message].merge!(:topic_id => @topic.id, :user_id => @current_user.id))
    flash[:notice] = "Message added." if @message.save
    respond_with :cp, @message, :location => cp_topic_messages_path(@topic, :page => @topic.last_page, :anchor => @message.id)
  end
  
  
  def edit
  end
  
  def update
    flash[:notice] = "Updated message." if @message.update_attributes(params[:message])
    respond_with :cp, @message, :location => cp_topic_messages_path(@message.topic, :page => @message.topic.last_page, :anchor => @message.id)
  end
  
  
  def destroy
    if @message.destroy
      flash[:notice] = "Deleted message."
    else
      flash[:alert] = "Message could not be deleted. Try again."
    end
    respond_with :cp, @message.topic, :messages
  end
  
  private
    def get_topic
      @topic = Topic.find(params[:topic_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Topic not found."
        redirect_to cp_forums_path
    end
    
    def get_message
      @message = Message.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Message not found."
        redirect_to cp_forums_path
    end
    
    def check_permissions
      return true if @current_user.allowed_to('admin') or @message.user == @current_user
      redirect_to cp_topic_messages_path(@topic) and return false
    end
    
    def check_if_locked
      @topic ||= @message.topic
      return true if !@topic.locked
      flash[:alert] = "This topic is locked. It is not accepting any changes or new replies."
      redirect_to cp_topic_messages_path(@topic) and return false
    end
end
