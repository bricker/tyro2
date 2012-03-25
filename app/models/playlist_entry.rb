class PlaylistEntry < ActiveRecord::Base
  belongs_to :schedule_event
  
  validates_presence_of :schedule_event_id, :title, :artist
  
  define_index do
    indexes title
    indexes artist
    indexes album
  end
  
  scope :after, lambda { |time| where("created_at > ?", Time.zone.at(time.to_i).utc) }
  scope :list_style, lambda { |style| order("created_at " + (style == "compact" ? "desc" : "asc")).limit(style == "compact" ? 5 : nil) }
  
  def self.latest
    where('playlist_entries.created_at > ?', Time.zone.now - 60*60).order('created_at desc').limit(5)
  end
end
