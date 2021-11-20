#!/bin/sh

# Directory has been already been created by cloud-config-drupal.yaml
chown --recursive ubuntu /run/cloud-config-drupal
# Assume user is ubuntu
mkdir /home/ubuntu/cloud-config-drupal
mkdir /home/ubuntu/cloud-config-drupal/install
cp /run/cloud-config-drupal/install/user-install.sh /home/ubuntu/cloud-config-drupal/install
chown --recursive ubuntu /home/ubuntu/cloud-config-drupal
# Add install script to the ubuntu user .profile file so it can run on login
sed -i -e '$a\\n#multipass-cloud-init-drupal\n$HOME/cloud-config-drupal/install/install-user.sh\n' /home/ubuntu/.profile
