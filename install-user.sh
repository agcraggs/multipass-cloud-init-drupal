#!/bin/bash

if [ ! -f "$HOME/cloud-config-drupal/.cloud-config-drupal" ]; then
  if [ -d "$HOME/cloud-config-drupal/install" ] ; then
    # Ready to install
    echo Starting: multipass-cloud-init-drupal
    echo Finishing: multipass-cloud-init-drupal
  fi
# Install complete
touch "$HOME/cloud-config-drupal/.cloud-config-drupal"
fi