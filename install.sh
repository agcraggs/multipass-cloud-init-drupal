#!/bin/sh

# Directory that has been already been created by cloud-config-drupal.yaml
cd /run/cloud-config-drupal/install
mkdir /run/cloud-config-drupal/setup
cd /run/cloud-config-drupal/setup
mkdir /home/ubuntu/bin
sudo usermod --append --groups www-data ubuntu
wget --output-document=composer-setup.php https://getcomposer.org/installer
php composer-setup.php --install-dir="/home/ubuntu/bin" --filename=composer --quiet
