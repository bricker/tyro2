# Feature: Special Events
# Background:
# 	Given I have logged in
# 	
# Scenario: Show link/page for management
# 	Given I have permission to manage schedule
# 	
# 	When I go to the cp root page
# 	And I follow "Special Events" in the management navigation
# 	
# 	Then I should see "Add Special Event"
# 	And the "Today & Later" tab should be highlighted
# 	And the "Earliest First" sub-nav link should be highlighted
# 	
# 	When I follow "Latest First"
# 	Then the "Latest First" sub-nav link should be highlighted
# 	
# 	When I follow "Before Today"
# 	Then the "Before Today" tab should be highlighted
# 	And the "Latest First" sub-nav link should be highlighted
# 				
# Scenario: Hide link/page for unauthorized users
# 	Given I have no permissions
# 	
# 	When I go to the cp root page
# 	Then I should not see "Special Events"
# 	
# 	When I go to the cp special events page
# 	Then I should not see "Add Special Event"
# 	And I should be on the cp root page
# 	
# 	When I go to the new cp special event page
# 	Then I should not see "Add Special Event"
# 	And I should be on the cp root page
# 
# Scenario: Create valid special event
# 	Given I have permission to manage schedule
# 	And a user with name "Dj Guy"
# 	
# 	When I go to the cp root page
# 	And I follow "Special Events" in the management navigation
# 	And I follow "Add Special Event"
# 	Then I should see the new special event form
# 	
# 	When I fill in "special event title" with "Super Special Event!"
# 	And I fill in "special event schedule event attributes starts at date" with "08/18/2020"
# 	And I fill in "special event schedule event attributes starts at time" with "5:30pm"
# 	And I fill in "special event schedule event attributes ends at date" with "08/18/2020"
# 	And I fill in "special event schedule event attributes ends at time" with "6:30pm"
# 	And I fill in "special event description" with "Event Description"
# 	And I fill in "special event user tokens" with the user
# 	And I submit the form
# 				
# 	Then I should see a success message
# 	And there should be 1 special event
# 	And there should be 1 schedule event
# 	And I should see "Super Special Event!"
# 	And the special event should have user "Dj Guy"
# 	And I should see "5:30"
# 	And I should see "pm"
# 	And I should see "August 18th"
# 	And I should see "2020"
# 	
# Scenario: Create invalid special event 
# 	Given I have permission to manage schedule
# 	When I go to the new cp special event page
# 	And I submit the form
# 	Then I should see the new special event form
# 	And I should be notified of errors
# 	And I should see "starts at date is invalid"
# 	And I should see "starts at time is invalid"
# 	And I should see "ends at date is invalid"
# 	And I should see "starts at time is invalid"
# 	And I should see "Title can't be blank"
# 	And I should see "Description can't be blank"
# 
# 	When I fill in "special event schedule event attributes starts at date" with "08/10/2011"
# 	And I submit the form
# 	Then I should not see "starts at date"
# 	And I should see "starts at time"
# 	
# 	When I fill in "special event schedule event attributes starts at time" with "8:00pm"
# 	And I submit the form
# 	Then I should not see "starts at time"
# 	And I should not see "starts at date"
# 	
# 	When I fill in "special event schedule event attributes starts at date" with "08/10/2011"
# 	And I fill in "special event schedule event attributes starts at time" with "some random string"
# 	And I submit the form
# 	Then I should see "starts at time"
# 	And I should not see "starts at date"
# 	
# 	When I fill in "special event schedule event attributes starts at date" with "08/10/2011"
# 	And I fill in "special event schedule event attributes starts at time" with "10:00pm"
# 	And I fill in "special event schedule event attributes ends at date" with "08/10/2011"
# 	And I fill in "special event schedule event attributes ends at time" with "9:00pm"
# 	And I submit the form
# 	Then I should see "has to be before the end time"
# 	
# Scenario: Edit special event
# 	Given I have permission to manage schedule
# 	And a special event
# 	
# 	When I go to the cp special events page
# 	And I follow "Manage"
# 	Then I should see the edit special event form
# 	
# 	When I fill in "special event title" with "Edited Event"
# 	And I fill in "special event schedule event attributes starts at date" with "08/18/2040"
# 	And I submit the form
# 	
# 	Then I should see a success message
# 	And I should see "Edited Event"
# 	And I should see "2040"
# 
# Scenario: Show Special Event Details
# 	Given I have permission to manage schedule
# 	And a special event
# 	
# 	When I go to the details page for that special event
# 	Then I should see the title of the event
# 	And the "Details" tab should be highlighted