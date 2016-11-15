Feature: Set a Backup Schedule for a Site
  In order to ensure the security of my site content
  As a user
  I need to be able to set my automated backup schedule.

  Background: I am authenticated and have a site named [[test_site_name]]
    Given I am authenticated
    And a site named "[[test_site_name]]"

  @vcr backup-schedule-set
  Scenario: Set the backup schedule for an environment
    When I run "terminus backup:schedule:set [[test_site_name]].test --day=Mon"
    Then I should get: "."
    And I should get "Backup schedule successfully set."
    When I run "terminus backup:schedule:get [[test_site_name]].test"
    Then I should get: "Monday"
