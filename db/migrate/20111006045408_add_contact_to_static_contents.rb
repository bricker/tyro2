class AddContactToStaticContents < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => "contact_box", :description => "Contact Box. Cached.", :content => "No Info Yet.")    
  end

  def self.down
  end
end
