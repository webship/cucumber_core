<?php

declare(strict_types=1);

namespace Drupal\cucumber_core\Plugin\views\area;

use Drupal\Core\Cache\CacheableMetadata;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Url;
use Drupal\views\Attribute\ViewsArea;
use Drupal\views\Plugin\views\area\AreaPluginBase;

/**
 * Prints the two links at the foot of a dashboard listing.
 *
 * The first link adds an item, the second one opens the full listing. A link
 * is only printed for the people who may follow it, and the two links are laid
 * out by the styles of this module, so the area looks the same in every theme.
 *
 * @ingroup views_area_handlers
 */
#[ViewsArea('cucumber_core_action_links')]
class ActionLinks extends AreaPluginBase {

  /**
   * The links of the area, in the order they are printed.
   */
  protected const LINKS = ['add', 'more'];

  /**
   * {@inheritdoc}
   */
  protected function defineOptions() {
    $options = parent::defineOptions();
    foreach (self::LINKS as $link) {
      $options[$link . '_title'] = ['default' => ''];
      $options[$link . '_path'] = ['default' => ''];
    }

    return $options;
  }

  /**
   * {@inheritdoc}
   */
  public function buildOptionsForm(&$form, FormStateInterface $form_state) {
    parent::buildOptionsForm($form, $form_state);

    $labels = [
      'add' => $this->t('The link that adds an item'),
      'more' => $this->t('The link to the full listing'),
    ];
    foreach (self::LINKS as $link) {
      $form[$link] = [
        '#type' => 'details',
        '#title' => $labels[$link],
        '#open' => TRUE,
      ];
      $form[$link . '_title'] = [
        '#type' => 'textfield',
        '#title' => $this->t('Link text'),
        '#default_value' => $this->options[$link . '_title'],
        '#fieldset' => $link,
      ];
      $form[$link . '_path'] = [
        '#type' => 'textfield',
        '#title' => $this->t('Path'),
        '#description' => $this->t('A path of this site that starts with a slash, for example /admin/people.'),
        '#default_value' => $this->options[$link . '_path'],
        '#fieldset' => $link,
      ];
    }
  }

  /**
   * {@inheritdoc}
   */
  public function validateOptionsForm(&$form, FormStateInterface $form_state) {
    parent::validateOptionsForm($form, $form_state);

    foreach (self::LINKS as $link) {
      $path = trim((string) $form_state->getValue(['options', $link . '_path']));
      if ($path !== '' && !str_starts_with($path, '/')) {
        $form_state->setError($form[$link . '_path'], $this->t('The path has to start with a slash.'));
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  public function render($empty = FALSE) {
    if ($empty && empty($this->options['empty'])) {
      return [];
    }

    $cacheability = (new CacheableMetadata())->addCacheContexts(['user.permissions']);
    $links = [];
    foreach (self::LINKS as $link) {
      $title = trim((string) $this->options[$link . '_title']);
      $path = trim((string) $this->options[$link . '_path']);
      if ($title === '' || !str_starts_with($path, '/')) {
        continue;
      }
      $url = Url::fromUserInput($path);
      $access = $url->access(NULL, TRUE);
      $cacheability->addCacheableDependency($access);
      if (!$access->isAllowed()) {
        continue;
      }
      $links[$link] = [
        '#type' => 'link',
        // The text comes from the configuration of the view, which is
        // translated as configuration.
        '#title' => $title,
        '#url' => $url,
        '#attributes' => [
          'class' => [
            'cucumber-core-action-links__link',
            'cucumber-core-action-links__link--' . $link,
          ],
        ],
      ];
    }

    $build = [];
    if ($links) {
      $build = [
        '#type' => 'container',
        '#attributes' => ['class' => ['cucumber-core-action-links']],
        '#attached' => ['library' => ['cucumber_core/action-links']],
      ] + $links;
    }
    $cacheability->applyTo($build);

    return $build;
  }

}
