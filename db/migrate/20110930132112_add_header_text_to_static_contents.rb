class AddHeaderTextToStaticContents < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => "no_event", :description => "Message to display on the home page when there is no live event.")
    StaticContent.create(:text_id => "header_text_birn1", :description => "Description for BIRN1 in the header.")
    StaticContent.create(:text_id => "header_text_birn2", :description => "Description for BIRN2 in the header.")
    StaticContent.create(:text_id => "header_text_birn3", :description => "Description for BIRN3 in the header.")
    StaticContent.create(:text_id => "header_text_birn4", :description => "Description for BIRN4 in the header.")
    StaticContent.create(:text_id => "header_text_birn5", :description => "Description for BIRN5 in the header.")
    StaticContent.create(:text_id => "header_text_birn_presents", :description => "Description for birn presents in the header.")
  end

  def self.down
  end
end