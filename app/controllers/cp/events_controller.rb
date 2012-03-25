class Cp::EventsController < Cp::BaseController
  before_filter :get_event, :only => [:playlist, :show, :edit, :update, :destroy]
  before_filter :check_if_can_manage_this_event, :only => [:playlist, :show, :edit, :update, :destroy]
  before_filter :check_if_can_manage_all_events, :only => [:index, :new, :create, :destroy]
  before_filter :get_tags, :only => [:edit, :new]
  
  respond_to :html, :js

  def index
    respond_with @events = Event.of_type(list).order('schedule_events.starts_at ' + order)
  end
  
  def show
    respond_with @event
  end
  
  def playlist
    respond_with @event
  end
  
  
  def new
    @event = Event.new
    @event.build_schedule_event
  end
  
  def create
    @event = Event.new(params[:event])
    flash[:notice] = "Added event" if @event.save
    respond_with :cp, @event
  end
  
  
  def edit
    respond_with @event
  end
  
  def update
    flash[:notice] = "Updated Special Event" if @event.update_attributes(params[:event])
    respond_with :cp, @event
  end
  
  
  def destroy
    if @event.destroy
      flash[:notice] = "Special Event Removed"
    else
      flash[:alert] = "Special Event could not be removed"
    end
    redirect_to cp_events_path
  end
  
  private    
    def get_event
      @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Event not found"
        redirect_to cp_events_path
    end
    
    def check_if_can_manage_this_event
      return true if @current_user.allowed_to('manage_events') or @event.users.include?(@current_user)
      redirect_to cp_root_path and return false
    end
    
    def check_if_can_manage_all_events
      return true if @current_user.allowed_to('manage_events')
      redirect_to cp_root_path and return false
    end
    
    def order
      %w{asc desc}.include?(params[:order]) ? params[:order] : "desc"
    end
    
    helper_method :list
    def list
      ScheduleEvent.get_event_type(params[:list], 'channel')[:id]
    end
end
