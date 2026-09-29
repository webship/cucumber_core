<?php

declare(strict_types=1);

namespace Drupal\cucumber_core\Hook;

use Drupal\Core\Hook\Attribute\Hook;
use Drupal\Core\StringTranslation\StringTranslationTrait;

/**
 * Views hooks for the Cucumber Core module.
 */
class CucumberCoreViewsHooks {

  use StringTranslationTrait;

  /**
   * Implements hook_views_data().
   */
  #[Hook('views_data')]
  public function viewsData(): array {
    $data = [];

    // The links at the foot of a dashboard listing.
    $data['views']['cucumber_core_action_links'] = [
      'title' => $this->t('Action links'),
      'help' => $this->t('A link that adds an item and a link to the full listing, each shown to the people who may follow it.'),
      'area' => [
        'id' => 'cucumber_core_action_links',
      ],
    ];

    return $data;
  }

}
