class AddRecurringFieldsToScheduleEvents < ActiveRecord::Migration
  def self.up
    add_column :schedule_events, :recurring, :boolean, :default => 0
    add_column :schedule_events, :first_occurrence_id, :integer
  end

  def self.down
    remove_column :schedule_events, :recurring
    remove_column :schedule_events, :first_occurrence_id
  end
end
