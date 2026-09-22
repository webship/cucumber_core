<?php

declare(strict_types=1);

namespace Drupal\cucumber_core\Plugin\views\style;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\Core\Template\Attribute;
use Drupal\views\Attribute\ViewsStyle;
use Drupal\views\Plugin\views\style\StylePluginBase;

/**
 * Renders each result row as a native HTML disclosure.
 *
 * The first field of the row becomes the `<summary>` a reader clicks, and the
 * remaining fields become the body of the `<details>`. Expanding and collapsing
 * is what the browser does with the element, so the listing needs no JavaScript
 * at all and keeps working when scripting is unavailable.
 *
 * @ingroup views_style_plugins
 */
#[ViewsStyle(
  id: 'cucumber_core_disclosure',
  title: new TranslatableMarkup('Disclosure list'),
  help: new TranslatableMarkup('Displays the rows as expandable disclosures. The first field is used as the summary a reader clicks to open the row.'),
  theme: 'cucumber_core_disclosure',
  display_types: ['normal'],
)]
class Disclosure extends StylePluginBase {

  /**
   * {@inheritdoc}
   */
  protected $usesRowPlugin = FALSE;

  /**
   * {@inheritdoc}
   */
  protected $usesRowClass = TRUE;

  /**
   * {@inheritdoc}
   */
  protected $usesFields = TRUE;

  /**
   * {@inheritdoc}
   */
  protected function defineOptions() {
    $options = parent::defineOptions();
    $options['open_first'] = ['default' => FALSE];

    return $options;
  }

  /**
   * {@inheritdoc}
   */
  public function render() {
    $this->view->element['#attached']['library'][] = 'cucumber_core/disclosure';

    return parent::render();
  }

  /**
   * Splits the result rows into a summary and the fields behind it.
   *
   * @return array
   *   A list of rows, each holding:
   *   - attributes: the HTML attributes of the disclosure.
   *   - summary: the rendered first field, which opens the row.
   *   - fields: the remaining fields, each with attributes and content.
   *   - open: whether the row starts open.
   */
  public function buildRows(): array {
    $this->renderFields($this->view->result);

    // The fields a reader gets to see, in the order the display puts them.
    $visible = [];
    foreach ($this->view->field as $id => $field) {
      if (empty($field->options['exclude'])) {
        $visible[] = $id;
      }
    }
    $summary_field = array_shift($visible);

    $rows = [];
    $position = 0;

    foreach (array_keys($this->view->result) as $index) {
      $classes = ['cucumber-disclosure'];
      if (!empty($this->options['default_row_class'])) {
        $classes[] = 'views-row';
      }
      $row_class = $this->getRowClass($index);
      if ($row_class) {
        $classes[] = $row_class;
      }

      $fields = [];
      foreach ($visible as $id) {
        $fields[] = [
          'id' => $id,
          'content' => $this->getField($index, $id),
          'attributes' => new Attribute([
            'class' => [
              'views-field',
              'views-field-' . str_replace('_', '-', $id),
            ],
          ]),
        ];
      }

      $rows[] = [
        'attributes' => new Attribute(['class' => $classes]),
        'summary' => $summary_field === NULL ? '' : $this->getField($index, $summary_field),
        'fields' => $fields,
        'open' => !empty($this->options['open_first']) && $position === 0,
      ];
      $position++;
    }

    return $rows;
  }

  /**
   * {@inheritdoc}
   */
  public function buildOptionsForm(&$form, FormStateInterface $form_state) {
    parent::buildOptionsForm($form, $form_state);

    $form['open_first'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Open the first row'),
      '#description' => $this->t('Show the first row expanded when the listing is loaded.'),
      '#default_value' => $this->options['open_first'],
    ];
  }

}
