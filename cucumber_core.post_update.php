<?php

/**
 * @file
 * Post update functions for the Cucumber Core module.
 */

/**
 * Show the state a feature is really in.
 */
function cucumber_core_post_update_current_feature_state(array &$sandbox): ?string {
  $entity_type_manager = \Drupal::entityTypeManager();
  if (!$entity_type_manager->hasDefinition('media') || !\Drupal::moduleHandler()->moduleExists('content_moderation')) {
    return NULL;
  }
  /** @var \Drupal\workflows\WorkflowInterface|null $workflow */
  $workflow = $entity_type_manager->getStorage('workflow')->load('automated_testing');
  if (!$workflow) {
    return NULL;
  }
  /** @var \Drupal\Core\Entity\ContentEntityStorageInterface $storage */
  $storage = $entity_type_manager->getStorage('media');

  if (!isset($sandbox['ids'])) {
    $sandbox['ids'] = array_values($storage->getQuery()
      ->accessCheck(FALSE)
      ->condition('bundle', 'feature')
      ->sort('mid')
      ->execute());
    $sandbox['total'] = count($sandbox['ids']);
    $sandbox['updated'] = 0;
  }

  $type = $workflow->getTypePlugin();
  foreach (array_splice($sandbox['ids'], 0, 25) as $id) {
    $latest_id = $storage->getLatestRevisionId($id);
    /** @var \Drupal\media\MediaInterface|null $latest */
    $latest = $latest_id ? $storage->loadRevision($latest_id) : NULL;
    if (!$latest || $latest->isDefaultRevision() || !$latest->hasField('moderation_state')) {
      continue;
    }
    $state = (string) $latest->get('moderation_state')->value;
    if (!$type->hasState($state) || !$type->getState($state)->isDefaultRevisionState()) {
      // A draft stays what it is: a revision that waits for its turn.
      continue;
    }
    // Nothing is rewritten: the newest revision, which holds the state the
    // feature was moved to, is saved once more, and Content Moderation makes
    // that new revision the current one.
    $latest->setNewRevision(TRUE);
    $latest->setRevisionCreationTime(\Drupal::time()->getRequestTime());
    $latest->setRevisionLogMessage('Made the current revision by the update of the automated testing workflow.');
    $latest->save();
    $sandbox['updated']++;
  }

  $sandbox['#finished'] = $sandbox['ids'] ? 1 - count($sandbox['ids']) / max($sandbox['total'], 1) : 1;
  if ($sandbox['#finished'] < 1) {
    return NULL;
  }

  return (string) \Drupal::translation()->formatPlural(
    $sandbox['updated'],
    'One feature now shows the state it was moved to.',
    '@count features now show the state they were moved to.',
  );
}
