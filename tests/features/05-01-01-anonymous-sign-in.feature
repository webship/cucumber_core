Feature: Anonymous visitors reach the log in page
  As a visitor who is not signed in
  I want every page to lead me to the log in page
  So that I can sign in, or ask for a new password, instead of facing an error

  Scenario: The front page leads to the log in page
    Given I am an anonymous user
    When I go to the homepage
    Then the path should be "/user/login"
     And I should see "Log in"
     And I should not see "Access denied"

  Scenario: A page of the site leads to the log in page, and back after it
    Given I am an anonymous user
    When I navigate to "/features"
    Then the path should be "/user/login"
     And current url should have the "destination" parameter with the "/features" value

  Scenario: The page that asks for a new password stays open
    Given I am an anonymous user
    When I navigate to "/user/password"
    Then the path should be "/user/password"
     And I should see "Reset your password"

  Scenario: Asking for a new password ends on a page the visitor can see
    Given I am an anonymous user
    When I navigate to "/user/password"
     And I fill in "Username or email address" with "admin_user"
     And I press "Submit"
    Then the path should be "/user/login"
     And I should not see "Access denied"

  Scenario: Anonymous Redirect is installed with its settings
    Given I am a logged in user with the "Webmaster" user
    When I navigate to "/admin/config/system/anonymous-redirect"
    Then the element "#edit-enable-anonymous-redirect" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-redirect-base-url" with the attribute "value" and the value "/user/login" should exist
     And I should see "/user/reset/*"
