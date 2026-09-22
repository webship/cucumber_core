Feature: The features listing expands without jQuery UI
  As a tester
  I want the features listing to open and close its rows
  So that I can read a Gherkin script without loading a JavaScript widget

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The Features view uses the disclosure list style
    When I navigate to "/admin/structure/views/view/features"
    Then I should see "Features"
     And eventually I should see "Disclosure list" within 15 seconds

  Scenario: The disclosure list style is offered to every view
    When I navigate to "/admin/structure/views/nojs/display/features/default/style"
    Then eventually I should see "Disclosure list" within 15 seconds

  Scenario: The jQuery UI accordion style is gone from the view
    When I navigate to "/admin/structure/views/nojs/display/features/default/style"
    Then I should not see "jQuery UI accordion"
