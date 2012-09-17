Feature: Tenacity role access
  As a tenacity researcher
  I should be able to see tenacity data
  I should not be able to see users or other data

  Background: A tenacity researcher is logged in
    Given a logged in tenacity researcher

  Scenario:
    When I am on the user index
    Then I should be at the homepage
    Then I should see access denied message

