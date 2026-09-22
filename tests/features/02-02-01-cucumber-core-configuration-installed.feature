Feature: Cucumber Core ships its default configuration
  As a site administrator
  I want the taxonomy, workflow and media configuration to land on install
  So that features can be written, classified and moderated out of the box

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The Feature Directory vocabulary is installed
    When I navigate to "/admin/structure/taxonomy"
    Then eventually I should see "Feature Directory" within 15 seconds
    When I navigate to "/admin/structure/taxonomy/manage/feature_directory/overview"
    Then I should see "Feature Directory"

  Scenario: The Automated testing workflow is installed
    When I navigate to "/admin/config/workflow/workflows"
    Then I should see "Automated testing"

  Scenario: The Feature media type is available
    When I navigate to "/admin/structure/media"
    Then I should see "Feature"

  Scenario: Media Directories is pointed at the Feature Directory vocabulary
    When I navigate to "/admin/config/media/media_directories"
    Then "#edit-directory-taxonomy" should have value "feature_directory"
