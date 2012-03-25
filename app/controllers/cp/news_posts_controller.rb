class Cp::NewsPostsController < Cp::BaseController
  before_filter :check_permissions
  before_filter :get_news_post, :except => [:index, :new, :create]
  
  respond_to :html
  def index
    respond_with @news_posts = NewsPost.page(params[:page]).per(5)
  end
  
  def show
    respond_with @news_post
  end
  
  
  def new
    respond_with @news_post = NewsPost.new
  end
  
  def create
    @news_post = NewsPost.new(params[:news_post])
    if @news_post.save
      flash[:notice] = "Added News Post" 
      redirect_to cp_news_posts_path
    else
      respond_with [:cp, @news_post]
    end
  end
  
  
  def edit
    respond_with @news_post
  end
  
  def update
    if @news_post.update_attributes(params[:news_post])
      flash[:notice] = "Updated News Post"
      redirect_to cp_news_posts_path
    else
      respond_with [:cp, @news_post]
    end
  end
  
  
  def destroy
    if @news_post.destroy
      flash[:notice] = "Removed News Post"
    else
      flash[:alert] = "Could not removed News Post"
    end
    respond_with [:cp, @news_post]
  end
  
  protected
    def check_permissions
      return true if @current_user.allowed_to('manage_news_posts')
      redirect_to cp_root_path and return false
    end
    
    def get_news_post
      @news_post = NewsPost.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to cp_news_posts_path, :alert => "News Post not found."
    end
end
