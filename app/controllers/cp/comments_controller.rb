class Cp::CommentsController < Cp::BaseController
  before_filter :get_comment, :except => :create
  before_filter :check_permissions, :except => :create
  respond_to :html
  
  def edit
    respond_with @comment
  end
  
  def create
    @comment = get_commentable.comments.build(params[:comment].merge!(:commenter_id => @current_user.id))
    if @comment.save
      flash[:notice] = "Comment added."
      respond_with @comment, :location => [:cp, @comment.commentable, :comments]
    else
      flash[:alert] = "Comment not added."
      redirect_to url_for([:cp, @comment.commentable, :comments])
    end
  end
  
  def update
    flash[:notice] = "Updated comment." if @comment.update_attributes(params[:comment])
    respond_with @comment, :location => [:cp, @comment.commentable, :comments]
  end
  
  def destroy
    if @comment.destroy
      flash[:notice] = "Comment deleted."
    else
      flash[:notice] = "Comment could not be deleted."
    end
    respond_with @comment, :location => [:cp, @comment.commentable, :comments]
  end
  
  private
    def get_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
    
    def get_comment
      @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Comment not found."
        redirect_to cp_root_path
    end
    
    def check_permissions
      return true if @current_user == @comment.commenter or @current_user.allowed_to('admin')
      redirect_to cp_root_path and return false
    end
end
