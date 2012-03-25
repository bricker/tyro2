class Cp::ShowsController < Cp::BaseController
  before_filter :get_show, :only => [:schedule, :playlist, :show, :edit, :update, :destroy, :edit_manage, :update_manage]
  before_filter :check_if_can_manage_schedule, :only => [:full_schedule, :schedule]
  before_filter :check_if_can_manage_all_shows, :only => [:edit_manage, :update_manage, :new, :create, :destroy] #MGs only
  before_filter :check_if_can_manage_this_show, :only => [:edit, :update, :playlist] #MGs and the DJs of this show
  
  respond_to :html, :js, :xml, :json
  
  def index
    if params[:list] == 'inactive'
      @shows = Show.inactive
    else
      @shows = Show.active
    end
    
    respond_with @shows.includes(:users)
  end
  
  def show
    respond_with @show
  end
  
  def search
    @shows = Show.where("title like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @shows.map { |s| { :id => s.id, :name => s.title } } }
    end
  end
  
  def schedule
    respond_with @show
  end
  
  def full_schedule
  end
  
  def playlist
    @schedule_events = @show.schedule_events.up_to(ScheduleEvent::UpTo)
    begin
      @schedule_event = params[:schedule_event_id].present? ? ScheduleEvent.find(params[:schedule_event_id]) : @schedule_events.last
    rescue ActiveRecord::RecordNotFound
      @schedule_event = @schedule_events.last
    end
  end
     
   
  def edit
    get_tags
    respond_with @show
  end
  
  def edit_manage
    @users = User.all
    respond_with @show
  end
  
  def update
    flash[:notice] = "Show Info Updated" if @show.update_attributes(params[:show])
	  respond_with(:cp, @show)
  end

  
  def new
    @show = Show.new
    @schedule_event = @show.schedule_events.build
    @users = User.all
  end
  
  def create
    @show = Show.new(params[:show])
    flash[:notice] = "Added #{@show.title}." if @show.save 
    respond_with(:cp, @show)
  end
  
  def destroy
  end
  
  private
    def get_show
      @show = Show.includes(:users).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to cp_shows_path, :alert => "Show not found."
    end
    
    def check_if_can_manage_schedule
      return true if @current_user.allowed_to('manage_schedule')
      redirect_to cp_shows_path and return false
    end      
    
    def check_if_can_manage_all_shows
      return true if @current_user.allowed_to('manage_shows')
      redirect_to cp_shows_path and return false
    end
    
    def check_if_can_manage_this_show
      return true if @current_user.allowed_to('manage_shows') or @show.users.include?(@current_user)
      redirect_to cp_shows_path and return false
    end
      
end
