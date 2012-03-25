class AddPreferredSlotsToSignups < ActiveRecord::Migration
  def self.up
    add_column :signups, :preferred_slots, :string
  end

  def self.down
    remove_column :signups, :preferred_slots
  end
end
