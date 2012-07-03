Feature: Player role access
  As a player
  I should not be able to view users or data

  Background: A player is logged in
    Given a logged in player

  Scenario:
    When I am on the user index
    Then I should be at the homepage
    Then I should see access denied message

  Scenario:
    When I am on the data index
    Then I should be at the homepage
    Then I should see access denied message

