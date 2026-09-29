Feature: The Features page asks for its own permission
  As a site administrator
  I want the Features page to open for the roles that work on features only
  So that a signed-in member without a role does not see the features

  Scenario: A member without a role may not open the Features page
    Given I am a logged in user with the "Authenticated user" user
    When I navigate to "/features"
    Then I should see "Access denied"
     And I should not see "Insert selected"
    When I navigate to "/media/add/feature"
    Then I should see "Access denied"

  Scenario: The Admin role opens the Features page, which is a listing
    Given I am a logged in user with the "Admin" user
    When I navigate to "/features"
    Then I should see "Features"
     And I should not see "Access denied"
     And I should not see "Insert selected"

  Scenario: The filter on the name finds a feature by a part of its name
    Given I am a logged in user with the "Admin" user
    When I navigate to "/features?name=workflow"
    Then I should see "Admin workflow feature"
    When I navigate to "/features?name=there-is-no-such-feature"
    Then I should not see "Admin workflow feature"
     And I should see "No features yet."

  Scenario: The Features view checks the permission of the Features page
    Given I am a logged in user with the "Webmaster" user
    When I navigate to "/admin/structure/views/nojs/display/features/default/access_options"
    Then the option "Access Features page" should be selected within the select element "#edit-access-options-perm"
