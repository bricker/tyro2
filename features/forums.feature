Feature: forums
		
# Scenario Outline: show/hide management for forums
# 	Given the following user records
# 		| email		 			 | 
# 		| admin@thebirn.com		 | 
# 		| management@thebirn.com | 
# 		| muggle@thebirn.com	 |	
# 	And the following forum record
# 		| subject	| order_rank	|
# 		| Forum1	| 1				|
# 		
# 	And I have logged in with email "<email>"
# 	And I have permission to <permission>
# 	
# 	When I follow "Forum" in the main navigation
# 	Then I should <action> "Add Forum"
# 	And I should <action> "Edit Forum"
# 
# 	Examples:
# 	   | email		 			 | permission		 			 | action	 |
# 	   | admin@thebirn.com		 | admin 					 	 | see		 |
# 	   | management@thebirn.com  | manage forums			     | see		 |
# 	   | muggle@thebirn.com	     | 					 	 		 | not see	 |