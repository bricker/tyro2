# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Add Permissions
Permission.create([
                    { :title => "admin",
                      :description => "Enable Everything" },
                      
                    { :title => "manage_user_info",
                      :description => "Edit DJ Profiles & Shows" },
                      
                    { :title => "manage_users_full",
                      :description => "Add/Edit/Comment on Users. Manage Training steps." },
                      
                    { :title => "manage_shows",
                      :description => "Add/Edit Shows" },
                      
                    { :title => "manage_problem_reports",
                      :description => "Edit/Close/Open Problem Reports" },
                      
                    { :title => "train_users",
                      :description => "Manage individual training progress and comment on users" },
                      
                    { :title => "manage_training_steps",
                      :description => "Add/Edit/Remove Training Steps" },
                        
                    { :title => "manage_news_posts",
                      :description => "Add/Edit News Posts on the Front End" },
                      
                    { :title => "manage_forums",
                      :description => "Add/Edit/Delete Forums, Topics, and Messages (Replies). Post Sticky/Global/Locked topics." },
                      
                    { :title => "manage_strikes",
                      :description => "Add/Edit Strikes. Comment on Users." },
                      
                    { :title => "manage_schedule",
                      :description => "Add/Edit All Schedule Events" },
                      
                    { :title => "edit_static_content",
                      :description => "Edit existing static content." },
                      
                    { :title => "manage_events",
                      :description => "Fully Manage Events." }
                  ])

# Add roles. The site will have errors without these.
Role.create(:title => 'noob')
Role.create(:title => 'dj')
Role.create(:title => 'management')
Role.create(:title => 'BIRN alumnus')
    
# Add initial user         
user = User.create(:email => 'webteam@thebirn.com', :name => "INITIAL USER (DELETE ME)")
user.password = "secret"
user.password_confirmation = "secret"
user.save
user.permissions << Permission.find_by_title('admin')

# Add Static blocks. Fill in content to avoid any potential nil errors.
StaticContent.create(:text_id => 'links_box', :description => 'Links list box on the front page.', :content => "No links yet.")
StaticContent.create(:text_id => 'about_channels', :description => 'List of Channels in the "About" page.', :content => "No channel information yet.")
StaticContent.create(:text_id => 'about_contact', :description => '"Contact" section of the "About" page. (does not include Contact box)', :content => "No information yet.")
StaticContent.create(:text_id => 'about_history', :description => 'The "History" section in the About page.', :content => "No information yet.")
StaticContent.create(:text_id => 'about_submissions', :description => 'Submission information on the About page', :content => "No information yet")
StaticContent.create(:text_id => "signup_start", :description => "The date and time to BEGIN signups.", :content => "closed")
StaticContent.create(:text_id => "signup_end", :description => "The date and time to END signups. (THROUGH)", :content => "closed")
StaticContent.create(:text_id => "signup_message", :description => "The message to display on the Signups page (at all times).", :content => "Signups are currently closed.")
StaticContent.create(:text_id => "resources", :description => "List of links on the Resources page in the Control Panel.", :content => "No resources to list yet.")
StaticContent.create(:text_id => "no_event", :description => "List of links on the Resources page in the Control Panel.", :content => "There is currently no event.")
StaticContent.create(:text_id => "header_text_birn1", :description => "Description for BIRN1 in the header.", :content => "Student Radio")
StaticContent.create(:text_id => "header_text_birn2", :description => "Description for BIRN2 in the header.", :content => "Concerts, Clinics, and more...")
StaticContent.create(:text_id => "header_text_birn3", :description => "Description for BIRN3 in the header.", :content => "Programming, News, and Music from Alumni")
StaticContent.create(:text_id => "header_text_birn4", :description => "Description for BIRN4 in the header.", :content => "Famous Recordings from Berklee Alumni")
StaticContent.create(:text_id => "header_text_birn5", :description => "Description for BIRN5 in the header.", :content => "The Berklee International Network on the BIRN")
StaticContent.create(:text_id => "header_text_birn_presents", :description => "Description for birn presents in the header.", :content => "Livecasts from the Red Room")
StaticContent.create(:text_id => "contact_box", :description => "Contact Box. Cached.", :content => "No Info Yet.")    
