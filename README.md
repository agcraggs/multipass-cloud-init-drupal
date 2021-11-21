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

## Cleanup

Host shell commands to clean up the instance `drupal01`:

`multipass stop drupal01`  
`multipass delete drupal01`  
`multipass purge`  

## Credits

Drupal 9 installation based on repository [Zigazou, drupal-vm](https://github.com/Zigazou/drupal-vm) without the need for bash, Python on the host.