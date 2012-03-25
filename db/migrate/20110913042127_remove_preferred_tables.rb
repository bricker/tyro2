class RemovePreferredTables < ActiveRecord::Migration
  def self.up
    drop_table :training_slots
    drop_table :preferred_training_slots
  end

  def self.down
  end
end
