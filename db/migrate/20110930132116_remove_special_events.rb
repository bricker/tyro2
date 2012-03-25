class RemoveSpecialEvents < ActiveRecord::Migration
  def self.up
    drop_table :special_events
    drop_table :special_events_users
  end

  def self.down
    create_table "special_events", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "special_events_users", :id => false, :force => true do |t|
      t.integer "special_event_id"
      t.integer "user_id"
    end
  end
end
