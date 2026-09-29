Feature: The steps of the automated testing workflow
  As a site administrator
  I want every step of the workflow to be named after where it leads
  So that I know what I grant when I give a role a step of the workflow

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The steps of the workflow are named after where they lead
    When I navigate to "/admin/config/workflow/workflows/manage/automated_testing"
    Then I should see "Send back to Draft"
     And I should see "Move to To Do"
     And I should see "Move to In Progress"
     And I should see "Move to Implemented"
     And I should see "Publish"
     And I should not see "Create New Task"

  Scenario: A feature that is moved to a state shows that state
    When I navigate to "/admin/config/workflow/workflows/manage/automated_testing/state/in_progress"
    Then the element "#edit-type-settings-default-revision" with the attribute "checked" and the value "checked" should exist
    When I navigate to "/admin/config/workflow/workflows/manage/automated_testing/state/to_do"
    Then the element "#edit-type-settings-default-revision" with the attribute "checked" and the value "checked" should exist
    When I navigate to "/admin/config/workflow/workflows/manage/automated_testing/state/implemented"
    Then the element "#edit-type-settings-default-revision" with the attribute "checked" and the value "checked" should exist

  Scenario: The Admin role may take every step
    When I navigate to "/admin/people/permissions/admin"
    Then the element "#edit-admin-use-text-format-gherkin" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-use-automated-testing-transition-back-to-draft" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-use-automated-testing-transition-create-new-task" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-use-automated-testing-transition-to-do" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-use-automated-testing-transition-in-progress" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-use-automated-testing-transition-implemented" with the attribute "checked" and the value "checked" should exist
     And the "#edit-admin-administer-media" checkbox should not be checked
     And the "#edit-admin-administer-users" checkbox should not be checked
