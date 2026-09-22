Feature: Cucumber Core module and its dependencies are enabled
  As a site administrator
  I want to verify that Cucumber Core and the modules it needs are installed
  So that the Cucumber testing management system is usable on plain Drupal

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Cucumber Core is listed as enabled
    When I navigate to "/admin/modules"
    Then I should see "Cucumber Core"
     And the element "#edit-modules-cucumber-core-enable" with the attribute "checked" and the value "checked" should exist

  Scenario: The modules Cucumber Core builds on are enabled
    When I navigate to "/admin/modules"
    Then the element "#edit-modules-gherkin-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-dashboards-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-media-directories-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-views-accordion-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-user-redirect-enable" with the attribute "checked" and the value "checked" should exist
