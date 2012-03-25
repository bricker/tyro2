class AddNewsToStaticContent < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => "tin_news", :description => "TIN News in the Control Panel", :content => "No News yet.")    
  end

  def self.down
  end
end
