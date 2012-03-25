class EventsController < ApplicationController
  before_filter :get_current_events, :get_channel_descriptions, :get_todays_events, :get_mbj_feed, :get_featured_dj, :get_links, :get_management, :get_tags, :get_contact
  
  respond_to :html
  def index
    @schedule_events = ScheduleEvent.of_schedulable_type("Event").page(params[:page]).per(3)
    @schedule_events = @schedule_events.of_type(event_type) if params[:event_type].present?
    respond_with @schedule_events = @schedule_events.future
  end
  
  def show
    respond_with @event = Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to events_path
  end
  
  protected
    def event_type
      ScheduleEvent::Types.any? { |t| t[:channel] == params[:event_type] } ? ScheduleEvent.get_event_type(params[:event_type], 'channel')[:id] : "BirnPresents"
    end
end
