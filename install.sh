#!/bin/sh

# Directory that has been already been created by cloud-config-drupal.yaml
chown ubuntu /run/cloud-config-drupal/install
cd /run/cloud-config-drupal/install
# Setup
mkdir /run/cloud-config-drupal/setup
chown ubuntu /run/cloud-config-drupal/setup
cd /run/cloud-config-drupal/setup
mkdir /home/ubuntu/bin
chown ubuntu /home/ubuntu/bin
usermod --append --groups www-data ubuntu
wget --output-document=composer-setup.php https://getcomposer.org/installer
php composer-setup.php --install-dir="/home/ubuntu/bin" --filename=composer --quiet
