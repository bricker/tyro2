class ChangeColumnInSlots < ActiveRecord::Migration
  def self.up
    rename_column :training_slots, :display, :when_daytime
  end

  def self.down
    rename_column :training_slots, :when_daytime, :display
  end
end
