#!/bin/bash

if [ ! -f "$HOME/cloud-config-drupal/.cloud-config-drupal" ]; then
  if [ -d "$HOME/cloud-config-drupal/install" ] ; then
    # Ready to install
    echo Starting: multipass-cloud-init-drupal
    SITE_ID=$(hostname)
    mkdir $HOME/cloud-config-drupal/setup
    cd $HOME/cloud-config-drupal/setup
    sudo usermod -a -G www-data ubuntu
    mkdir $HOME/bin
    BIN=$HOME/bin

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Composer
wget --output-document=composer-setup.php https://getcomposer.org/installer
php composer-setup.php --install-dir="$BIN" --filename=composer --quiet

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Drush
composer global require drush/drush
# Make drush available anywhere
for vendorbin in ~/.config/composer/vendor/bin/*
do
    ln --symbolic "$vendorbin" ~/bin/$(basename "$vendorbin")
done

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Database    
sudo mysql -u root << EOF
    CREATE USER $SITE_ID@localhost IDENTIFIED BY "$SITE_ID";
    CREATE DATABASE $SITE_ID;
    GRANT ALL ON $SITE_ID.* TO $SITE_ID@localhost;
    FLUSH PRIVILEGES;
    EXIT
EOF

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Drupal 9

cd /var/www

sudo mkdir -- "$SITE_ID"
sudo chown $USER:$USER "$SITE_ID"

composer \
    --no-interaction \
    create-project drupal/recommended-project \
    "$SITE_ID"

cd /var/www/$SITE_ID

composer \
    --no-interaction \
    require drush/drush

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Configure Drupal 9

cd /var/www/$SITE_ID

# Let Drush configure the database for us
drush --yes site-install \
    --site-name "$SITE_ID" \
    --account-name=admin \
    --account-pass=admin \
    --db-url="mysql://$SITE_ID:$SITE_ID@localhost/$SITE_ID"

# Change group permission for the files directory, otherwise Drupal won't be
# able to write into it (which means no visible theme)
sudo chgrp -R www-data /var/www/$SITE_ID/web/sites/default/files

sudo find /var/www/$SITE_ID/web/sites/default/files \
    -type d \
    -exec chmod g+s \{\} \;

# Configure the Claro administrative theme
drush --yes theme:enable claro
drush --yes config:set system.theme admin claro

# Configure trusted host patterns
HYPERVISOR_IP=$(echo "$SSH_CONNECTION" \
    | awk '{ print $3 }' \
    | sed 's/\./\\./g' \
)

chmod u+w /var/www/$SITE_ID/web/sites/default/settings.php

cat >> /var/www/$SITE_ID/web/sites/default/settings.php <<EOF

/**
 * Trusted host patterns
 */
\$settings['trusted_host_patterns'] = [
  '^localhost\$',
  '^127\\.0\\.0\\.1\$',
  '^$HYPERVISOR_IP\$',
];
EOF

chmod u-w /var/www/$SITE_ID/web/sites/default/settings.php

    echo Virtual host
# Enable the rewrite module for Drupal clean URLs
sudo a2enmod rewrite
sudo a2dissite 000-default.conf

# PHP FPM is needed for UploadProgress
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.4-fpm

sudo tee /etc/apache2/sites-available/$SITE_ID.conf << EOF
<VirtualHost *:80>
    ServerAdmin admin@$SITE_ID.com
    DocumentRoot /var/www/$SITE_ID/web
    ServerName  $SITE_ID.com
    ServerAlias www.$SITE_ID.com

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/$SITE_ID/web/>
        Options FollowSymlinks
        AllowOverride All
        Require all granted

        RewriteEngine on
        RewriteBase /
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^(.*)\$ index.php?q=\$1 [L,QSA]
    </Directory>
</VirtualHost>
EOF

sudo a2ensite $SITE_ID.conf

sudo systemctl restart apache2

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo cron job

BIN=~/bin

# Run cron job every 5 minutes
printf '%s /usr/bin/env PATH=%s COLUMNS=%d %s/drush --root=%s --quiet cron\n' \
    '*/5 * * * *' \
    "$PATH" \
    72 \
    "$BIN" \
    "/var/www/$SITE_ID" \
    > /tmp/mycron

crontab /tmp/mycron

rm /tmp/mycron

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo Finishing: multipass-cloud-init-drupal
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
    echo IP address

ip -o -4 addr | awk '{print $4}'
  fi
# Install complete
touch "$HOME/cloud-config-drupal/.cloud-config-drupal"
fi