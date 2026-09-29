Feature: The Admin role writes a feature and moves it through the workflow
  As a member of the Admin role
  I want to write a feature with its Gherkin script and move it from step to step
  So that the listings show the state every feature is in

  Background:
    Given I am a logged in user with the "Admin" user

  Scenario: The Admin role may use the Gherkin script field
    When I navigate to "/media/add/feature"
    Then I should see a "Name" field
     And ".ace_editor" should be visible within 15 seconds
     And I should not see "you do not have sufficient permissions"
     And the option "Draft" should exist within the select element "#edit-moderation-state-0-state"
     And the option "To Do" should exist within the select element "#edit-moderation-state-0-state"
     And the option "In Progress" should exist within the select element "#edit-moderation-state-0-state"
     And the option "Implemented" should exist within the select element "#edit-moderation-state-0-state"
     And the option "Published" should exist within the select element "#edit-moderation-state-0-state"

  Scenario: The Admin role writes a feature with a Gherkin script
    When I navigate to "/media/add/feature"
     And I fill in "Name" with "Admin workflow feature"
     And I fill in the Ace editor with:
      """
      Feature: Sign in
        Scenario: A visitor opens the log in page
          Given I am on "/user/login"
          Then I should see "Log in"
      """
     And I press "Save"
    Then I should see "Feature Admin workflow feature has been created."
     And I should not see "You do not have access to transition"
    When I navigate to "/features?name=Admin%20workflow%20feature"
    Then I should see "To Do" in the "Admin workflow feature" row

  Scenario Outline: The Admin role moves the feature to "<state>"
    When I navigate to "/features?name=Admin%20workflow%20feature"
     And I click "Edit" in the "Admin workflow feature" row
     And I select "<state>" from "Change to"
     And I press "Save"
    Then I should see "Feature Admin workflow feature has been updated."
    When I navigate to "/features?name=Admin%20workflow%20feature"
    Then I should see "<state>" in the "Admin workflow feature" row

    Examples:
      | state       |
      | In Progress |
      | Implemented |
      | Published   |
      | To Do       |

  Scenario: The Admin role sends the feature back to Draft, and on to To Do
    When I navigate to "/features?name=Admin%20workflow%20feature"
     And I click "Edit" in the "Admin workflow feature" row
     And I select "Draft" from "Change to"
     And I press "Save"
    Then I should see "Feature Admin workflow feature has been updated."
    When I navigate to "/features?name=Admin%20workflow%20feature"
     And I click "Edit" in the "Admin workflow feature" row
    Then I should see "Draft" in the "#edit-moderation-state-0-current" element
    When I select "To Do" from "Change to"
     And I press "Save"
    Then I should see "Feature Admin workflow feature has been updated."
    When I navigate to "/features?name=Admin%20workflow%20feature"
    Then I should see "To Do" in the "Admin workflow feature" row
