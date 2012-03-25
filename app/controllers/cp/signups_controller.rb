class Cp::SignupsController < Cp::BaseController
  skip_before_filter :login_required, :only => [:new, :create, :show]
  before_filter :check_permissions, :only => :index
  before_filter :signups_open, :only => [:new, :create]
  
  respond_to :html, :js
  def index
    @signups = Signup.order('created_at')
  end
  
  def show
  end
  
  def new
    @message = StaticContent.find_by_text_id("signup_message")
    respond_with @signup = Signup.new
  end
  
  def create
    @signup = Signup.new(params[:signup])
    @signup.preferred_slots = params[:preferred_slots].join("--")
    flash[:notice] = "You have successfully signed up. You will receive an e-mail soon with more information. Thanks!" if @signup.save
    redirect_to cp_signup_path(@signup)
  end
  
  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy
    respond_with @signup
  end  
  
  helper_method :signups_open
  def signups_open #using instance variables here to get NilClass instead of undefined if Chronic returns nil.
    begin
      @now = Chronic.parse(Time.zone.now.to_s) 
      @signup_start = Chronic.parse(StaticContent.find_by_text_id("signup_start").content)
      @signup_end = Chronic.parse(StaticContent.find_by_text_id("signup_end").content)
      
      if @signup_start && @signup_end # make sure Chronic doesn't return null
        return true if @signup_start <= @now && @now < @signup_end
      end
      flash.now[:alert] = "Signups are currently closed." and return false
      
    rescue #if for some reason the signup_start and signup_end aren't in the DB. 
      flash.now[:alert] = "Signups are currently closed." and return false
    end
  end
  
  protected    
    def check_permissions
      return true if @current_user.allowed_to('manage_users_full')
      redirect_to cp_root_path and return false
    end
end
