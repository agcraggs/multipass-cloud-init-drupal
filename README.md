# multipass-cloud-init-drupal

[Drupal](https://www.drupal.org/home) VM creation using [Multipass](https://multipass.run) using a [cloud-init](https://ubuntu.com/blog/using-cloud-init-with-multipass) metadata file.

## Launch

Host shell commands to pass the cloud-init metadata file `cloud-config-drupal.yaml` to launch an instance named `drupal-vm-01`:

`multipass launch -n drupal-vm-01 --cloud-init cloud-config-drupal.yaml`

## Logs

Instance shell commands to check on the logs:

`cloud-init status --long`  
`cat /var/log/cloud-init.log`  

## Cleanup

Host shell commands to clean up the instance `drupal-vm-01`:

`multipass stop drupal-vm-01`  
`multipass delete drupal-vm-01`  
`multipass purge`  
