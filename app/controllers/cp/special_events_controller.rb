class Cp::SpecialEventsController < Cp::BaseController
  before_filter :check_permissions
  before_filter :get_special_event, :only => [:show, :edit, :update, :destroy]
  
  respond_to :html
  
  #TODO: Soft-Delete

  def index
    if params[:list] == 'before_today'
      @special_events = SpecialEvent.before_today
    else
      @special_events = SpecialEvent.today_and_later
    end
    
    respond_with @special_events = @special_events.order('schedule_events.starts_at ' + order)
  end
  
  def show
  end
  
  
  def new
    @special_event = SpecialEvent.new
    @special_event.build_schedule_event
  end
  
  def create
    @special_event = SpecialEvent.new(params[:special_event])
    flash[:notice] = "Added special event" if @special_event.save
    respond_with :cp, @special_event, :location => cp_special_events_path
  end
  
  
  def edit
    respond_with @special_event
  end
  
  def update
    flash[:notice] = "Updated Special Event" if @special_event.update_attributes(params[:special_event])
    respond_with :cp, @special_event
  end
  
  
  def destroy
    if @special_event.destroy
      flash[:notice] = "Special Event Removed"
    else
      flash[:alert] = "Special Event could not be removed"
    end
    respond_with :cp, @special_event
  end
  
  private
    def check_permissions
      return true if @current_user.allowed_to 'manage_schedule'
      redirect_to cp_root_path and return false
    end
    
    def get_special_event
      @special_event = SpecialEvent.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Special Event not found"
        redirect_to cp_root_path
    end
    
    def order
      %w{asc desc}.include?(params[:order]) ? params[:order] : "asc"
    end
end
