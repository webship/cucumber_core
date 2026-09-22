# Cucumber Core

Provides the core configuration for the Cucumber Automated Functional
Acceptance Testing Management system: the media, taxonomy, workflow and
dashboard configuration that turns a Drupal site into a place where
Gherkin feature scripts are written, classified and moderated.


## Table of contents

- Features
- Requirements
- Installation
- Configuration
- Usage


## Features

- A "Feature Directory" taxonomy vocabulary used to classify features.
- An "Automated testing" content moderation workflow.
- A `field_description` field on media and a `field_description` plus
  `field_features` field storage on nodes.
- Views for the feature library, the media library and the dashboard
  blocks (features, feature directory, last content, my team).
- A "Default Dashboard" and an "Admin Dashboard" built from the
  `dashboards` module, plus an `admin` role that may view both.
- An `access features page` permission.
- Two recipes, run from `hook_install()`:
  - `recipes/media-directories-settings` points Media Directories at
    the `feature_directory` vocabulary.
  - `recipes/cucumber-dashboards` creates the `admin` role when it is
    missing and grants it both dashboard permissions.


## Requirements

Drupal core `^11.4 || ^12`, plus the contributed modules listed in
`composer.json`:

- [Webpatches](https://www.drupal.org/project/webpatches)
- [Webconfig](https://www.drupal.org/project/webconfig)
- [Webdev](https://www.drupal.org/project/webdev)
- [Webadmin](https://www.drupal.org/project/webadmin)
- [Webassets](https://www.drupal.org/project/webassets)
- [Gherkin Script](https://www.drupal.org/project/gherkin)
- [Views Accordion](https://www.drupal.org/project/views_accordion)

Those in turn bring in Dashboards, Media Directories, Token Filter,
Autocomplete Deluxe, Gin Login and User Redirect, which are all listed
as module dependencies in `cucumber_core.info.yml`. No asset-packagist,
`npm-asset` or `bower-asset` repositories are needed.


## Installation

Install as you would normally install a contributed Drupal module:

```
composer require drupal/cucumber_core
drush en cucumber_core
```


## Configuration

Nothing has to be configured by hand. Installing the module runs both
recipes and installs the default and optional configuration. Review the
result at:

- `admin/structure/taxonomy` - the Feature Directory vocabulary.
- `admin/config/workflow/workflows` - the Automated testing workflow.
- `admin/config/media/media_directories` - the directory vocabulary.
- `admin/structure/dashboards` - the Default and Admin dashboards.
- `admin/people/permissions/admin` - the dashboard permissions granted
  to the `admin` role.


## Usage

Log in and open `/dashboard/admin_dashboard` or
`/dashboard/default_dashboard`. Feature scripts are added as "Feature"
media items (provided by the Gherkin Script module), filed under a
Feature Directory term, and moved through the Automated testing
workflow.

Automated functional tests for this module live in `tests/` and are run
with [webship-js](https://www.npmjs.com/package/webship-js); see
`tests/README.md`.
