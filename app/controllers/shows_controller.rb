class ShowsController < ApplicationController
  before_filter :get_todays_events, :get_current_events, :get_channel_descriptions, :get_management, :get_tags, :get_contact
  
  respond_to :html, :js
    
  def show
    if @show = Show.includes(:users).find_by_id(params[:id]) or @show = Show.includes(:users).find_by_url_slug(params[:id]) # this is a workaround since I SEO'd the URLs, to keep from breaking old links
      @events = @show.schedule_events.up_to(0).reverse # hax - reverse because default_scope won't let me override order [edit:] actually I can with the "reorder" scope.
      @posts = @show.posts.page(params[:page]).per(3)
      @management = User.has_role("management")
    else
      redirect_to root_path, :alert => "Couldn't find that show. Try the Explore box on the right!"
    end
  end
  
  def update_playlist
    @event = ScheduleEvent.find(params[:schedule_event_id])
    respond_with @playlist_entries = @event.playlist_entries.order('created_at')
  end
end
