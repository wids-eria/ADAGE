Feature: User management
  As an admin
  I want to create many users at once
  So that user registration is effective in classroom environments

  Background: The admin is logged in
    Given a logged in admin

  Scenario: Create many users with prefix
    Given I am on the mass user form
    When I create "10" users with prefix "ada_student" and start value "3"
    Then I should have users
     And I should be at the users index

  Scenario: List users
    Given 5 users
    When I am on the user index
    Then I should see the users
