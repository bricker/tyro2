class AddSignupInfoToStaticContent < ActiveRecord::Migration
  def self.up
    StaticContent.create(:text_id => "signup_start", :description => "The date and time to BEGIN signups.", :content => "September 15th, 2011 at 6am")
    StaticContent.create(:text_id => "signup_end", :description => "The date and time to END signups. (THROUGH)", :content => "September 16th, 2011 at 11:59pm")
    StaticContent.create(:text_id => "signup_message", :description => "The message to display on the Signups page (at all times).", :content => "")
  end

  def self.down
  end
end
