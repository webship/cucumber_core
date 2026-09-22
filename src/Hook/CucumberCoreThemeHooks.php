<?php

declare(strict_types=1);

namespace Drupal\cucumber_core\Hook;

use Drupal\cucumber_core\Plugin\views\style\Disclosure;

/**
 * Theme preprocess for the Cucumber Core views styles.
 *
 * Views registers this class automatically for the theme hook of a style
 * plugin provided by this module.
 *
 * @see \Drupal\views\Hook\ViewsThemeHooks::theme()
 * @see \Drupal\cucumber_core\Plugin\views\style\Disclosure
 */
class CucumberCoreThemeHooks {

  /**
   * Prepares the rows of the disclosure list style.
   *
   * @param array $variables
   *   The theme variables of the `cucumber_core_disclosure` hook.
   */
  public function preprocessCucumberCoreDisclosure(array &$variables): void {
    $style = $variables['view']->style_plugin;

    if (!$style instanceof Disclosure) {
      return;
    }

    $variables['rows'] = $style->buildRows();
  }

}
