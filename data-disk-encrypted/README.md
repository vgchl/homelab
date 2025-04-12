# data-drive

This CoreOS ISO is a bit different from the rest because it doesn't install CoreOS to the disk, but simply formats the disk and configures LUKS and automated unlocking with Clevis and Tang.

Therefore, use the `create-iso.sh` script instead of the regular builder.
