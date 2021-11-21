# multipass-cloud-init-drupal

[Drupal](https://www.drupal.org/home) VM creation using [Multipass](https://multipass.run) using a [cloud-init](https://ubuntu.com/blog/using-cloud-init-with-multipass) metadata file.

## Installation

Install [Multipass](https://multipass.run)  
Download this repository  
Follow Launch to create a VM instance

## Launch

Host shell commands to pass the cloud-init metadata file `cloud-config-drupal.yaml` to launch an instance named `drupal01`:

`multipass launch -n drupal01 --cloud-init cloud-config-drupal.yaml`

The instance name `drupal01` is used later for usernames, passwords. Some characters that can be used in an instance name are not valid for usernames, passwords and will result in installation errors.

When lauching an instance shell for the first time the Drupal 9 instalation process will automatically be triggered. At the end of the installation process the IP address is printed and can be used with a web browser to view the Drupal site.

## cloud-init Logs

Instance shell commands to check on the logs:

[Debugging cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/debugging.html)  
`sudo cloud-init status --long`  
`sudo cloud-init analyze show`  

## Drupal 9 Installation

The Drupal 9 installation is for development use has the following characteristics if you have used `drupal01` as the site ID:

- **VM user/password**: ubuntu/ubuntu
- **Database/user/password**: `drupal01`/`drupal01`/`drupal01`
- **Drupal user/password**: admin/admin
- **Web site configuration**: /etc/apache2/sites-available/`drupal01`.conf
- **Document root**: /var/www/`drupal01`/web
- **Apache2/PHP logs**: /var/log/apache2/access.log, /var/log/apache2/error.log
- Drupal 9 has been entirely installed using Composer and Drush
- Composer and Drush are available from the command line of the ubuntu user
- UploadProgress extension is installed
- APCu cache is installed
- Cron job is configured to run every 5 minutes (it uses drush cron)
- Trusted host patterns are configured on the VM IP address

## Post Drupal 9 Installation Developer Setup

To facilitate ease of development on the host it is helpful to mount the relevant local directories inside the instance. Suggested multipass host shell mount commands post installation. Generic share directory:

`multipass mount <source>/multipass/drupal01/share drupal01:/home/ubuntu/share`

From the Drupal `README.txt`: You may create subdirectories in this directory `/var/www/drupal01/web/modules`, to organize your added modules, without breaking the site. Some common subdirectories include "contrib" for contributed modules, and "custom" for custom modules. Note that if you move a module to a subdirectory after it has been enabled, you may need to clear the Drupal cache so it can be found.

There are number of directories that are ignored when looking for modules. These are 'src', 'lib', 'vendor', 'assets', 'css', 'files', 'images', 'js', 'misc', 'templates', 'includes', 'fixtures' and 'Drupal'.

Common Drupal subdirectories:

`multipass mount <source>/multipass/drupal01/contrib drupal01:/var/www/drupal01/web/modules/contrib`  
`multipass mount <source>/multipass/drupal01/custom drupal01:/var/www/drupal01/web/modules/custom`

Example "custom" Drupal 9 modules: To be placed into `<source>/multipass/drupal01/custom` on the host:

[drupal-modules-custom](https://github.com/agcraggs/drupal-modules-custom)

## Cleanup

Host shell commands to clean up the instance `drupal01`:

`multipass stop drupal01`  
`multipass delete drupal01`  
`multipass purge`  

## Credits

Drupal 9 installation based on repository [Zigazou, drupal-vm](https://github.com/Zigazou/drupal-vm) without the need for bash, Python on the host.