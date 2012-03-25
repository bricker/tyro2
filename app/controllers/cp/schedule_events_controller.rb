class Cp::ScheduleEventsController < Cp::BaseController
  before_filter :get_schedulable, :only => [:index, :new]
  before_filter :get_event, :only => [:show, :edit, :update, :move, :destroy]
  before_filter :check_permissions
  respond_to :html, :js, :xml, :json
  
  def index
    @events = @schedulable ? @schedulable.schedule_events : ScheduleEvent.unscoped.of_schedulable_type(params[:schedulable_type])
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    respond_with @events.includes(:schedulable)
  end
  
  def show
    respond_with @event
  end
  
  
  def new
    respond_with @event = ScheduleEvent.new(:starts_at => ScheduleEvent.parse_iso(params[:start]), :ends_at => ScheduleEvent.parse_iso(params[:end]))
  end
  
  def create
    @event = ScheduleEvent.new(params[:schedule_event])
    if @event.save
      @event.delay.create_recurring(params[:schedule_event][:recur_through]) if params[:schedule_event][:recur_through].present?
    end # TODO: Handle what to do if it's not saved
    respond_with :cp, @event
  end
  
  
  def edit
    @schedulable = @event.schedulable
    respond_with @event
  end
  
  def update
    if @event.update_attributes(params[:schedule_event])
      @event.delay.create_recurring(params[:schedule_event][:recur_through]) if params[:schedule_event][:recur_through].present? && !@event.recurring
    end
    respond_with :cp, @event
  end
  
  def recur
    if params[:recur_select_start].present? && params[:recur_through].present?
      ScheduleEvent.recur_multiple(params[:recur_select_start], params[:recur_through])
      redirect_to cp_shows_path, :notice => "Recurring events are being created. Please check the schedule in 5-10 minutes."
    else 
      redirect_to full_schedule_cp_shows_path, :alert => "You need to fill in both date fields to set recurring events"
    end
  end
  
  def move # drag and resize.
    @event.delay.move_multiple(params[:change_start], params[:change_end]) if params[:update_all] == "true"
    @event.move_one(params[:schedule_event][:starts_at], params[:schedule_event][:ends_at], params[:update_all].eql?("true"))
    respond_with :cp, @event
  end
  
  def destroy
    @event.destroy
    respond_with :cp, @event
  end
  
  protected
    def check_permissions
      return true if @current_user.allowed_to('manage_schedule')
      redirect_to cp_shows_path and return false
    end
    
    def get_event
      @event = ScheduleEvent.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Event not found"
        redirect_to cp_shows_path
    end
    
    def get_schedulable
      @schedulable = params[:schedulable_type].classify.constantize.find(params[:schedulable_id]) if params[:schedulable_type].present? && params[:schedulable_id].present?
    end
end
