class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :event_type
      t.timestamps
    end
    
    create_table :events_users, :id => false do |t|
      t.integer :event_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :events
    drop_table :events_users
  end
end
