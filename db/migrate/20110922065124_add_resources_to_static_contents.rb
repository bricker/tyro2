class AddResourcesToStaticContents < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => "resources", :description => "List of links on the Resources page in the Control Panel.")
  end

  def self.down
  end
end
