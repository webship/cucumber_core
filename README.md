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
- An "Automated testing" content moderation workflow. A feature goes from
  Draft to To Do, In Progress, Implemented and Published, and every step
  is named after where it leads: "Move to To Do", "Move to In Progress",
  "Move to Implemented", "Publish" and "Send back to Draft". The listings
  show the state a feature was moved to.
- A `field_description` field on media and a `field_description` plus
  `field_features` field storage on nodes.
- Views for the feature library, the media library and the dashboard
  blocks (features, feature directory, last content, my team).
- A "Default Dashboard" and an "Admin Dashboard" built from the
  `dashboards` module, plus an `admin` role that may view both.
- An `access features page` permission, which the Features page at
  `/features` asks for.
- Anonymous visitors are sent to `/user/login` by
  [Anonymous Redirect](https://www.drupal.org/project/anonymous_redirect).
  The pages of a password reset stay open, and a one-time log in link
  leads to the account form, where the new password is set.
- Recipes, run from `hook_install()`:
  - `recipes/foundation` installs the module with its configuration and
    the settings of Anonymous Redirect.
  - `recipes/media-directories-settings` points Media Directories at
    the `feature_directory` vocabulary.
  - `recipes/cucumber-dashboards` creates the `admin` role when it is
    missing and grants it both dashboard permissions.
  - `recipes/user-role-admin` lets the `admin` role write a feature with
    its Gherkin script, file it in a feature directory and move it
    through every step of the workflow. The role gets no permission that
    administers the site.


## Requirements

Drupal core `^11.4 || ^12`, plus the contributed modules listed in
`composer.json`:

- [Webpatches](https://www.drupal.org/project/webpatches)
- [Webconfig](https://www.drupal.org/project/webconfig)
- [Webdev](https://www.drupal.org/project/webdev)
- [Webadmin](https://www.drupal.org/project/webadmin)
- [Webassets](https://www.drupal.org/project/webassets)
- [Gherkin Script](https://www.drupal.org/project/gherkin)
- [Anonymous Redirect](https://www.drupal.org/project/anonymous_redirect)

Those in turn bring in Dashboards, Media Directories, Token Filter,
Autocomplete Deluxe and User Redirect, which are all listed
as module dependencies in `cucumber_core.info.yml`. No asset-packagist,
`npm-asset` or `bower-asset` repositories are needed.

### Non-stable dependencies

Two of those projects have no stable release that works on Drupal 11:

- [Media Directories](https://www.drupal.org/project/media_directories)
  — newest release `3.0.0-rc1` (**rc**). Its stable `2.0.x` releases cap
  at `drupal/core ^8.8.3 || ^9`, so `composer.json` pins
  `drupal/media_directories`, `drupal/media_directories_ui` and
  `drupal/media_directories_editor` to `^3.0@rc` rather than letting
  drupal.org's Composer facade derive an unconstrained `*` from
  `cucumber_core.info.yml`.
- [Display Builder](https://www.drupal.org/project/display_builder) —
  newest release `1.0.0-beta7` (**beta**), required by Webassets.
- [Config Update](https://www.drupal.org/project/config_update) —
  newest release `2.0.0-alpha4` (**alpha**), required by Webconfig.

Composer only honours stability flags (`@rc`, `@beta`, `@alpha`) in the
**root** `composer.json`; a flag inside a dependency is ignored. So a
site that requires Cucumber Core has to relax the stability itself:

```json
{
    "minimum-stability": "beta",
    "prefer-stable": true,
    "require": {
        "drupal/config_update": "^2.0@alpha"
    }
}
```

With `prefer-stable` every other package still resolves to its stable
release.


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
- `admin/structure/webdashboards` - the Default and Admin dashboards.
- `admin/people/permissions/admin` - the permissions granted to the
  `admin` role.
- `admin/config/system/anonymous-redirect` - where anonymous visitors
  are sent.


## Usage

Log in and open `/webdashboard/admin_dashboard` or
`/webdashboard/default_dashboard`. Feature scripts are added as "Feature"
media items (provided by the Gherkin Script module), filed under a
Feature Directory term, and moved through the Automated testing
workflow.

Automated functional tests for this module live in `tests/` and are run
with [webship-js](https://www.npmjs.com/package/webship-js); see
`tests/README.md`.
