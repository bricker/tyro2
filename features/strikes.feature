# Feature: Strikes
# 
# Background:
# 	Given I have logged in
# 	
# Scenario: show link for management
# 	Given I have permission to manage strikes
# 	
# 	When I go to the cp root page
# 	And I follow "Users" in the management navigation
# 	
# 	Then I should see "3+ Strikes"
# 	
# Scenario: view strikes for one user as management
# 	Given a user
# 	And I have permission to manage strikes
# 	
# 	When I go to the cp root page
# 	And I follow "Users" in the management navigation
# 	And I follow the "Strikes" link for the user
# 	
# 	Then I should see a tab labeled "Strikes"
# 	And the "Strikes" tab should be highlighted
# 	And I should see "Add Strike"
# 	
# Scenario: view strikes for one user as owner
# 	Given I have no permissions
# 	
# 	When I go to the cp root page
# 	And I follow "My Profile" in the main navigation
# 	And I follow the "Strikes" tab
# 	
# 	Then the "Strikes" tab should be highlighted
# 	And I should not see "Add Strike"
# 	
# Scenario: create valid strike for user
# 	Given a user
# 	And I have permission to manage strikes
# 	
# 	When I go to the cp root page
# 	And I follow "Users" in the management navigation
# 	And I follow the "Strikes" link for the user
# 	And I follow "Add Strike"
# 	
# 	Then I should see the new strike form
# 	
# 	When I fill in "strike_offense_on" with "01/01/2011"
# 	When I fill in "comment_body" with "comment text"
# 	And I submit the form
# 	
# 	Then I should see a success message
# 	And I should see "Missed Meeting"
# 	And there should be 1 strike
# 	And there should be 1 comment
# 	
# Scenario: try to create invalid strike for user
# 	Given a user
# 	And I have permission to manage strikes
# 	
# 	When I go to the cp root page
# 	And I follow "Users" in the management navigation
# 	And I follow the "Strikes" link for the user
# 	And I follow "Add Strike"
# 	
# 	Then I should see the new strike form
# 	
# 	When I submit the form
# 	
# 	Then I should see the new strike form
# 	And I should be notified of errors
# 	
# 	