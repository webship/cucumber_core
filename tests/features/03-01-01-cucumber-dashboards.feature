Feature: Cucumber Core dashboards
  As a site administrator
  I want the default and admin dashboards installed and granted to the admin role
  So that testers land on a dashboard that lists their features

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Both Cucumber dashboards are listed
    When I navigate to "/admin/structure/webdashboards"
    Then I should see "Admin Dashboard"
     And I should see "Default Dashboard"

  Scenario: The admin dashboard renders
    When I navigate to "/webdashboard/admin_dashboard"
    Then I should see "Admin Dashboard"

  Scenario: The default dashboard renders
    When I navigate to "/webdashboard/default_dashboard"
    Then I should see "Default Dashboard"

  Scenario: The Admin role may view both dashboards
    When I navigate to "/admin/people/roles"
    Then I should see "Admin"
    When I navigate to "/admin/people/permissions/admin"
    Then the element "#edit-admin-can-view-admin-dashboard-webdashboard" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-admin-can-view-default-dashboard-webdashboard" with the attribute "checked" and the value "checked" should exist
