class AddEventsToPermissions < ActiveRecord::Migration
  def self.up
    Permission.create({ :title => "manage_events",
      :description => "Fully Manage Events." })
  end

  def self.down
  end
end
