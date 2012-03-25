Feature: User Authentication

Background:
	Given I am a user with email "test@user.com" and password "secret"
	And I am on the login page

Scenario: User Logs in with Correct Information
	When I fill in the form with email "test@user.com" and password "secret"
	And I submit the form
	Then I should be on the cp root page
	And my information should be displayed at the top
	
Scenario: User Logs in with Incorrect Password
	When I fill in the form with email "test@user.com" and password "WRONG"
	And I submit the form
	Then I should be sent back to the login page
	And I should see an alert message
	
Scenario: User Logs in with Incorrect Email
	When I fill in the form with email "WRONG@user.com" and password "secret"
	And I submit the form
	Then I should be sent back to the login page
	And I should see an alert message