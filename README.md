Freifunk Ulm
============

For more information see http://ulm.freifunk.net

Running our firmware
--------------------
(you need some flavour of OpenWrt on your router for this to work)

* check out the branch matching your router
* run `scripts/flash.pl -m model`; add `-X` if what you saw seemed to make some sense (if you see a reboot command then everything went well and you can abort the script)
* when the router has booted, run `scripts/access.pl -T -a ~/.ssh/id_rsa.pub`. This sets the root password to `vince27brown`.
* run `scripts/mount_etc.pl` and have a look at `git status` to see the files that differ between the repository and the newly flashed router.
* run `git checkout --patch` and discard everything that should be replaced with defaults from the repository (typically you want to discard everything but `shadow` and `shadow-`)
* run `scripts/umount_etc.pl` and power cycle the router for the changes to take effect.
