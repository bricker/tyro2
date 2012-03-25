class ScheduleEvent < ActiveRecord::Base
  belongs_to :schedulable, :polymorphic => true
  has_many :playlist_entries
  has_many :recurrences, :class_name => "ScheduleEvent", :foreign_key => 'first_occurrence_id'
  belongs_to :first_occurrence, :class_name => "ScheduleEvent"
    
  # OPTIMIZE Cleanup this model.

  attr_accessor :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :recur_through
  attr_reader :show_token
  def show_token=(id)
    self.schedulable_type = 'Show'
    self.schedulable_id = id
  end
    
  TimeOffset = 60*60*5 # seconds to offset the schedule for the front end display purposes ONLY. No longer being used.
  LookAhead = 60*60*18 # seconds to look ahead in the schedule for the front-end widget.
  UpTo = 1 # how far ahead to look.
  
  Types = [ {:id => 'Birn1', :title => "BIRN1", :channel => "birn1" }, # if no channel, just use a parameter-friendly string, ex. "berklee-events"
            {:id => 'Birn2', :title => "BIRN2", :channel => "birn2" },
            {:id => 'BirnPresents', :title => "birn presents", :channel => "birn-presents" } ]
            
    def self.get_event_type(value=Types.first[:id], by_key='id')
      Types.find { |type| type[by_key.to_sym] == value } || Types.first
    end
    
  validates_each :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time do |record, attr, value|
    record.errors.add(attr, " is invalid") if !Chronic.parse(value.to_s)
  end
  
  validate :starts_at_is_before_ends_at
    def starts_at_is_before_ends_at
      return unless errors.blank?
      self.parse_dates
      errors.add(:base, "Event can't end before it starts, McFly.") if starts_at > ends_at
    end

  def parse_dates
    self.starts_at = Chronic.parse("#{starts_at_date} #{starts_at_time}")
    self.ends_at = Chronic.parse("#{ends_at_date} #{ends_at_time}")
  end
  
  def move_one(event_start, event_end, update_all=false)
    if !update_all
      self.recurring = false
      self.first_occurrence_id = nil
    end
    self.starts_at = ScheduleEvent.parse_iso(event_start)
    self.ends_at = ScheduleEvent.parse_iso(event_end)
    save(:validate => false)
  end
  
  def move_multiple(change_start, change_end)
    sibling_recurrences.starts_after(starts_at).each do |event|
      event.starts_at += change_start.to_i
      event.ends_at += change_end.to_i
      event.save(:validate => false)
    end
  end

  def self.recur_multiple(recur_start, recur_through)
    of_schedulable_type("Show").where('recurring = 0').starts_after(Chronic.parse(recur_start + " 12am")).each { |event| event.delay.create_recurring(recur_through) }
  end
  
  def create_recurring(recur_through_date)
    self.update_attribute(:recurring, true) # set the first_occurrence to recurring = true
    
    date = Chronic.parse(recur_through_date + " 11:59pm")
    frequency = 7.days
    start_date = starts_at + frequency
    end_date = ends_at + frequency
    added = []
    
    while date > start_date      
      event = ScheduleEvent.find_or_initialize_by_starts_at_and_ends_at_and_schedulable_type_and_schedulable_id(start_date, end_date, schedulable_type, schedulable_id)
      event.recurring = true
      event.first_occurrence_id = id if event.new_record?
      event.event_type = event_type
      added << event if event.save(:validate => false)
      
      start_date += frequency
      end_date += frequency
    end
    return added
  end
    
  after_save :save_schedulable, :if => "schedulable.present? and schedulable_type == 'Show' and first_occurrence.blank?" # this is just so the associated show's "Active" status gets set properly. There is a callback to set it in the Show model.
  after_destroy :save_schedulable, :if => "schedulable.present? and schedulable_type == 'Show' and first_occurrence.blank?"
    def save_schedulable
      schedulable.updated_at = Time.zone.now
      schedulable.save
    end
  
  default_scope order('starts_at, created_at DESC') # If two events are happening at the same time, the event which starts first has priority. If two events start at the exact same time, the event which was created LAST has priority.
  scope :after, lambda {|start_time| where("ends_at > ?", ScheduleEvent.format_date(start_time))}
  scope :starts_after, lambda {|start_time| where("starts_at >= ?", start_time) }
  scope :before, lambda {|end_time| where("starts_at < ?", ScheduleEvent.format_date(end_time))}
  scope :future, lambda { where('ends_at > ?', Time.zone.now) } #includes any future events, plus the current event
  scope :up_to, lambda { |hours| where('starts_at <= ?', Time.zone.now + 60*60*hours) } #all events up to 'hours' from now. Allows users to start playlist entry early, for example.
  scope :of_type, lambda { |type| where('event_type = ?', type) }
  scope :of_schedulable_type, lambda { |type| where('schedulable_type = ?', type) }
  scope :coming, lambda { where('ends_at > ? AND starts_at < ?', Time.zone.now, Time.zone.now + LookAhead) } # lambda means it will be evaluated when it's called, important for the Time
  
  def self.current # returns an array of all events going on right now.
    where('starts_at <= :now AND ends_at > :now', :now => Time.zone.now)
  end
  
  def sibling_recurrences # FIXME Fix this method to include SELF for fetching recur_through. Possibly just make a recur_through attribute.
    first_occurrence_id.nil? ? recurrences : ScheduleEvent.where('first_occurrence_id = ? AND id != ?', first_occurrence_id, id)
  end
  
  def as_json(options = {})
    options ||= {}
    {
      :id => id,
      :title => schedulable.title,
      :start => no_tz(starts_at),
      :end => no_tz(ends_at),
      :recurring => recurring,
      :url => if self.new_record?  # OPTIMIZE This needs to be better.
                nil 
              elsif options[:frontpage].blank?
                Rails.application.routes.url_helpers.edit_cp_schedule_event_path(id, :format => :js)
              elsif schedulable_type == "Show"
                Rails.application.routes.url_helpers.show_path(schedulable)
              elsif schedulable_type == "Event"
                Rails.application.routes.url_helpers.event_path(schedulable)
              else
                Rails.application.routes.url_helpers.root_path
              end     
   }
  end
  
  def self.parse_iso(date_time)
    Time.zone.parse(date_time).in_time_zone(Time.zone) - Time.zone.now.utc_offset # Convert UTC to Time.zone, but keep hour the same. Hack because Fullcalendar displays everything in UTC.
  end
  
  def self.format_date(date_time) #formats UNIX timestamp into a Time object in Time.zone
    Time.zone.at(date_time.to_i) - Time.zone.now.utc_offset
  end
  
  def no_tz(date_time) # Returns ISO8601-formatted date without TimeZone so FullCalendar will be timezone-agnostic (same date/time no matter what)
    date_time.strftime("%Y-%m-%dT%H:%M:%S")
  end
  
  def title
   schedulable.title
  end
  
  def description
    schedulable.description
  end
  
  def length
    ((self.ends_at - self.starts_at)/60/60).to_i
  end
  
end
