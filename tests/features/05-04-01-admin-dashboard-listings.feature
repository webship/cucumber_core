Feature: The listings of the admin dashboard
  As a member of the Admin role
  I want every listing of the admin dashboard to be there, with its links
  So that I reach the features, the feature directories and the team

  Background:
    Given I am a logged in user with the "Admin" user

  Scenario: The admin dashboard has its three listings
    When I navigate to "/dashboard/admin_dashboard"
    Then I should see "Admin Dashboard"
     And I should see "Features"
     And I should see "Feature Directory"
     And I should see "My Team"
     And I should see "Admin workflow feature"

  Scenario: The links of the Feature Directory listing are laid out by Cucumber Core
    When I navigate to "/dashboard/admin_dashboard"
    Then I should see a ".cucumber-core-action-links" element by attr
     And the link "Add Directory" with the href "/admin/structure/taxonomy/manage/feature_directory/add" within the element ".cucumber-core-action-links" should exist
     And the link "See More" with the href "/admin/structure/taxonomy/manage/feature_directory/overview" within the element ".cucumber-core-action-links" should exist
     And ".cucumber-core-action-links" should have the CSS "display" set to "flex"

  Scenario: A link the role may not follow is not printed
    When I navigate to "/dashboard/admin_dashboard"
    Then I should not see "Add User"

  Scenario: An empty listing says so
    When I navigate to "/dashboard/admin_dashboard?name=there-is-no-such-feature"
    Then I should see "No features in this state yet."

  Scenario: The Admin role adds a feature directory
    When I navigate to "/dashboard/admin_dashboard"
     And I click "Add Directory"
     And I fill in "Name" with "Sign in features"
     And I press "Save"
    Then I should see "Created new term Sign in features."
