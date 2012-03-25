class AddStaticContents < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => 'links_box', :description => 'Links list box on the front page.')
    StaticContent.create(:text_id => 'about_channels', :description => 'List of Channels in the "About" page.')
    StaticContent.create(:text_id => 'about_contact', :description => '"Contact" section of the "About" page. (does not include Contact box)')
    StaticContent.create(:text_id => 'about_history', :description => 'The "History" section in the About page.')
    StaticContent.create(:text_id => 'about_submissions', :description => 'Submission information on the About page')
  end

  def self.down
  end
end
