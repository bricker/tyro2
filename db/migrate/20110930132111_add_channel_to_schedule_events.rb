class AddChannelToScheduleEvents < ActiveRecord::Migration
  def self.up
    add_column :schedule_events, :event_type, :string
    ScheduleEvent.of_schedulable_type('Show').each { |s| s.update_attribute('event_type', 'Birn1') }
    ScheduleEvent.of_schedulable_type('Event').each { |s| s.update_attribute('event_type', s.schedulable.event_type) }
    
    remove_column :events, :event_type
  end

  def self.down
    remove_column :schedule_events, :event_type
    add_column :events, :event_type, :string
  end
end
