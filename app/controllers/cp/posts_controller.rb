class Cp::PostsController < Cp::BaseController
  before_filter :get_show
  before_filter :check_permissions
  before_filter :get_post, :only => [:show, :edit, :update, :destroy]
  
  respond_to :html
  
  def index
    respond_with @posts = @show.posts.page(params[:page]).per(5)
  end
  
  def show
  end
  

  def edit
    respond_with @post
  end

  def update
    flash[:notice] = "Post Updated" if @post.update_attributes(params[:post])
    respond_with :cp, @show, @post, :location => cp_show_posts_path(@show)
  end
  
  
  def new
    respond_with(@post = Post.new)
  end

  def create
    @post = Post.new(params[:post].merge!(:show_id => params[:show_id], :user_id => @current_user.id))
    flash[:notice] = "Added Post." if @post.save
    respond_with :cp, @show, @post, :location => cp_show_posts_path(@show)
  end


  def destroy
    if @post.destroy
      flash[:notice] = "Deleted Post."
    else
      flash[:alert] = "Could not delete post. Try again."
    end
    respond_with :cp, @show, @post
  end
  
  
  protected    
    def get_show
      @show = Show.find(params[:show_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Show not found."
        redirect_to cp_shows_path
    end
    
    def check_permissions
      return true if @current_user.allowed_to("manage_shows") or @show.users.include?(@current_user)
      redirect_to cp_show_path(@show) and return false
    end
    
    def get_post
      @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Post not found."
        redirect_to cp_show_posts_path(@show)
    end
end
