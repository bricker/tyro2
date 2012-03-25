Feature: Users

Background:
	Given I have logged in

Scenario: hide link for unauthorized users
	Given I have no permissions
	When I go to the cp root page
	Then I should not see "Users"
	When I go to the cp users page
	Then I should be on the cp root page
	When I go to the new cp user page
	Then I should be on the cp root page
	
Scenario: Add single valid user
	Given I have the following permissions:
	 | permission        |
	 | manage_users_full |

	When I go to the cp users page
	And I follow "Add Users"
	And I fill in "name" with "Bryan Ricker"
	And I fill in "email" with "bricker@thebirn.com"
	And I submit the form
	Then there should be 2 users
	
Scenario: Add a single invalid user
	Given I have "manage users full" permission
	When I go to the new cp user page
	And I submit the form
	Then I should be notified of errors
	And there should be 1 user

Scenario: Soft delete a user
	Given I have the "manage users full" permission
	And a user with the following attributes:
	 | name       |
	 | Joe Schmoe |

	When I go to that user's edit page
	And I follow "Remove" in the sub-nav
	And I check "deleted bool"
	And I check "deleted bool confirmation"
	Then I should see a success message
	And the user should have no email
	And the user should be soft-deleted
	
Scenario: Reset Password and Send Welcome Email
	Given I have permission to manage users full
	And a user with the following attributes:
	 | name       |
	 | Joe Schmoe |
	
	When I go to the cp users page
	And I go to that user's edit page
	And I follow "Manage" in the sub-nav
	And I follow "resend_welcome"
	Then I should see a success message
	And there should be 1 e-mail sent
	And the last e-mail sent should be to that user
