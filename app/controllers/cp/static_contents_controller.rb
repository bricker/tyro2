class Cp::StaticContentsController < Cp::BaseController
  before_filter :check_permissions
  before_filter :get_static_content, :except => :index
  
  respond_to :html
  def index
    respond_with @static_contents = StaticContent.all
  end
  
  def show
    respond_with @static_content
  end
  
  def edit
    respond_with @static_content
  end
  
  def update
    if @static_content.update_attributes(params[:static_content])
      expire_fragment(/sc_.+/) # Expires all static content caches (any fragment starting with `sc_` in its name - links, header, contact, etc.)
      redirect_to cp_static_contents_path, :notice => "Updated Content."
    else
      respond_with [:cp, @static_content]
    end
  end
  
  protected
    def check_permissions
      return true if @current_user.allowed_to('edit_static_content')
      redirect_to cp_root_path and return false
    end
    
    def get_static_content
      @static_content = StaticContent.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Static Content not found."
        redirect_to cp_root_path
    end
end
