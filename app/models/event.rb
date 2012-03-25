class Event < ActiveRecord::Base
  has_one :schedule_event, :as => :schedulable, :dependent => :destroy
  has_and_belongs_to_many :users
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings, :uniq => true
  include TagAccessor # tag_tokens setter and getter. found in /lib folder.
  
  define_index do # thinking_sphinx
    indexes title
    indexes description
    indexes tags(:name), :as => :tags
    
    has schedule_event(:starts_at), :as => :starts_at
  end
    
  accepts_nested_attributes_for :schedule_event
  validates_presence_of :title, :description, :event_type
    
  attr_reader :user_tokens
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  default_scope includes(:schedule_event)
  scope :of_type, lambda { |types| where('schedule_events.event_type IN (?)', types) }
  
  def self.next # must be called last... not technically a scope.
    where('schedule_events.starts_at > ?', Time.zone.now).order('schedule_events.starts_at').first
  end
  
  def self.cleanup_old_events(days=7)
    before_date = Time.zone.now - days.days
    events = joins(:schedule_event).where('schedule_events.ends_at <= ?', before_date).all
    deleted = destroy(events.map(&:id))
    
    # logging for cron
    puts "============================================================\n"
    puts "== Event#cleanup_old_events on #{Time.zone.now}\n"
    puts "============================================================\n"
    puts "== Destroyed #{deleted.count} Events (ending on or before #{before_date})\n\n"
    deleted.each do |event|
      puts event.to_yaml + "\n"
    end
    puts "=========================== end ============================\n\n"
  end
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def starts_at
    schedule_event.starts_at
  end
  
  def ends_at
    schedule_event.ends_at
  end
  
  def event_type
    schedule_event.event_type
  end
end