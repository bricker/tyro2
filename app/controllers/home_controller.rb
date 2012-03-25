class HomeController < ApplicationController
  before_filter :get_current_events, :only => [:index, :playlist, :news, :explore, :update_current_events, :update_playlist]
  before_filter :get_next_event, :only => [:index, :update_next_event]
  before_filter :get_channel_descriptions, :except => [:feed, :livecam, :wrongbrowser, :sources, :update_playlist]
  before_filter :get_todays_events, :only => [:index, :playlist, :news, :explore]
  before_filter :get_mbj_feed, :only => [:index, :news]
  before_filter :get_featured_dj, :only => [:index, :playlist, :news, :explore]
  before_filter :get_links, :only => [:index, :news]
  before_filter :get_management, :except => [:feed, :livecam, :wrongbrowser, :sources, :update_playlist]
  before_filter :get_tags, :only => [:index, :playlist, :news]
  before_filter :get_contact, :only => [:index, :playlist, :explore, :news]
  
  respond_to :html, :js, :json
  
  Channels =  [{ :title => "Birn1", :channel => 'birn1', :file => 'channel-1'},
              { :title => "Birn2", :channel => 'birn2', :file => 'channel-2'},
              { :title => "Birn3", :channel => 'birn3', :file => 'channel-3'},
              { :title => "Birn4", :channel => 'birn4', :file => 'channel-4'},
              { :title => "Birn5", :channel => 'birn5', :file => 'channel-5'},
              { :title => "birn-presents", :channel => 'birn-presents', :file => 'birn-presents'}]
              
  def index
    @news_posts = NewsPost.limit(1)
  end
  
  def playlist
    @playlist_entries = PlaylistEntry.page(params[:page]).per(50).order('created_at DESC').includes(:schedule_event)
  end
  
  def feed
    render :text => "No Feed"
  end
  
  def channel_redirect    
    channel = Channels.find{|c| c[:channel] == params[:channel]}
    if channel.present?
      redirect_to "http://streams.thebirn.com/berklee-radio/#{channel[:file]}.m3u"
    else
      redirect_to channels_path
    end
  end
  
  def stream
    @channel = Channels.find{|c| c[:channel] == params[:channel]}
    render :layout => 'minimal'
  end
  
  def explore
    # First, lazy-load any model we want to search.
    @playlist_entries = PlaylistEntry.search(params[:query]).page(params[:page]).per(30)
    @shows = Show.search(params[:query], :field_weights => { :tags => 10, :title => 5, :description => 1 }, :order => 'active DESC, @relevance DESC').page(params[:page]).per(10)
    @events = Event.search(params[:query], :field_weights => { :tags => 10, :title => 5, :description => 1 },
                            :order => :starts_at).page(params[:page]).per(5)
    
    # Array of accepted search types. Order matters - If no param[:search_type] is specified, this is the order that it will look in.
    @search_types = [{ :title => "Shows", :param => 'shows', :response => @shows },
                     { :title => "Playlist", :param => 'playlist', :response => @playlist_entries },
                     { :title => "Events", :param => 'events', :response => @events }]
                  
    # Now check that params[:search_type] is in the accepted types, and return the search type
    @results = @search_types.find { |t| t[:param] == params[:search_type] } if params[:search_type].present?
    
    # If @results is blank (i.e. either params[:search_type] is not accepted, including nil), then run through each search_type and check if the query has any results.
    # this will always be run when visiting /explore without a search_type defined. This will make sure that if there are results for any of the search_types, a "no results" page won't be displayed.
    # "no results" will only be displayed if there are no results at all, or if a search_type is specified and there are no results for that search_type. i.e. /explore/playlist will always *only* search in the Playlists.
    @results = @search_types.find{ |search_type| search_type[:response].present? } if @results.blank?
    
    # Finally, if nothing was found at all, then just return an empty hash so the view can tell the person that "Experimental Electronic Gregorian Chants" isn't a very popular choice.
    respond_with @results ||= {}
    
    rescue Riddle::ConnectionError # If Sphinx is not running.
      redirect_to root_path, :alert => "Our search feature is currently offline. Check back soon."
  end
    
  def sources
    @events = ScheduleEvent.of_schedulable_type(schedulable_type).of_type(event_type)
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    respond_to do |format|
      format.js { render :json => @events.includes(:schedulable).to_json(:frontpage => true) }
      format.html
    end
  end
  
  def news
    @news_posts = NewsPost.page(params[:page]).per(4)
  end
  
  def update_playlist
    @current_event = ScheduleEvent.find(params[:current_event_id])
    @playlist_entries = @current_event.playlist_entries.order('created_at DESC').limit(5) if @current_events.include? @current_event
    respond_with @playlist_entries
  end
  
  def update_current_events # FIXME this and update_next_event make the Facebook box disappear.
    respond_with @current_events
  end
  
  def update_next_event
    respond_with @next_event
  end
  
  def livecam
    render :layout => 'minimal'
  end
  
  def wrongbrowser
    render :layout => 'minimal'
  end
  
  protected
    def schedulable_type # This will have to be expanded if we add more than the two types.
      params[:source] == 'shows' ? 'Show' : 'Event'
    end
    
    def event_type # this could be a little better
      ScheduleEvent::Types.any? { |t| t[:id] == params[:source] } ? params[:source] : "Birn1"
    end
  
    helper_method :get_no_event_text
    def get_no_event_text
      @no_event_text = StaticContent.find_by_text_id("no_event").content rescue "There is currently no show."
    end

    def get_next_event
      @next_event = Event.where("schedule_events.schedulable_type = 'Event'").next
    end
end
