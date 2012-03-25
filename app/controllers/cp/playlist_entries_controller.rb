class Cp::PlaylistEntriesController < Cp::BaseController
  before_filter :get_schedule_event, :only => [:playlist, :edit, :update, :create, :destroy]
  before_filter :get_playlist_entry, :only => [:edit, :update, :destroy]
  before_filter :check_permissions, :only => [:playlist, :edit, :update, :create, :destroy]
  
  respond_to :html, :js
  
  # FIXME Small CSS error on the "do it" link for the iTunes box.
  def playlist
    @all_playlist_entries = PlaylistEntry.scoped # just a dump of all the playlist entries for autocomplete, for index.js.erb. # OPTIMIZE The new playlist page loads slowly because of this
    @playlist_entries = @schedule_event.playlist_entries.order('created_at')
    respond_with @schedule_event
  end
  
  def create
    @playlist_entry = PlaylistEntry.create(params[:playlist_entry].merge!(:schedule_event_id => @schedule_event.id))
    respond_with [:cp, @schedule_event, @playlist_entry]
  end
  
  
  def edit
    respond_with @playlist_entry
  end
  
  def update
    @playlist_entry.update_attributes(params[:playlist_entry])
    respond_with [:cp, @schedule_event, @playlist_entry]
  end
  
  
  def destroy
    @playlist_entry.destroy
    respond_with :cp, @playlist_entry
  end
  
  protected
    def get_schedule_event
      @schedule_event = ScheduleEvent.find(params[:schedule_event_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to cp_root_path, :alert => "Event Not Found."
    end
    
    def get_playlist_entry
      @playlist_entry = PlaylistEntry.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to cp_root_path, :alert => "Playlist Entry not found."
    end
    
    def check_permissions
      return true if @current_user.allowed_to("manage_shows", "manage_events") or @schedule_event.schedulable.users.include?(@current_user)
      redirect_to cp_root_path and return false
    end
end
