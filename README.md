### Introduction
**Lxc-service-snapshots** run disposable (read-only then delete) Linux containers (LXC) to serve up [OpenVPN](https://openvpn.net/), [Pi-Hole](https://pi-hole.net/), and [WireGuard](https://www.wireguard.com/).

Lxc-service-snapshots creates a temporary clone (a new container) from a "base container" via an overlayfs mount. The overlayfs mount is very innovative in that it is a read-only copy of the base container. Only the changes are written to the snapshotted container so all key system files are protected since they are by design, read-only. When stopped, the snapshotted container is completely destroyed leaving the base container untouched with the exception of a few config and data files unique to Pi-Hole. These are saved and injected back into the base image by lxc-service-snapshots.

Notable advantages of snapshotting include:
- Increased security.  This is particularly true if the snapshotted container is facing the Internet via forwarded ports.  Since the primary file system is mounted back to the base LXC via a read-only overlay, and since the snapshotted LXC is destroyed upon systemd stopping it, anything potentially compromised therein is also destroyed.
- Simplified administrative overhead (i.e. updates to the base LXC are seamlessly applied to all snapshotted containers by virtue of the overlayfs mount).
- Minimized disk space and system resources.

### Scope
Use this software if you wish to:
- Run an Internet-facing instance of OpenVPN configured in server mode.
- Run Pi-Hole.
- Run an Internet-facing instance of WireGuard.

### Installation
- To build from source, see the included INSTALL file.
- ![logo](http://www.monitorix.org/imgs/archlinux.png "arch logo") Arch Linux users 

### Prerequisites
A user configured "base" container containing the need dependencies for either OpenVPN, Pi-hole, or WireGuard.  This includes configuring, firewall setup, etc.  This setup is beyond the scope of this guide.  Refer to the following if needed:
- [Linux_Containers](https://wiki.archlinux.org/index.php/Linux_Containers)
- [Pi-Hole](https://wiki.archlinux.org/index.php/Pi-hole)
- [OpenVPN_(server)_in_Linux_containers](https://wiki.archlinux.org/index.php/OpenVPN_(server)_in_Linux_containers)
- [WireGuard](https://wiki.archlinux.org/index.php/WireGuard)

Note - Do not enable any systemd services specific to pi-hole or openvpn in the base. Lxc-service-snapshots will do this. Do enable the firewall in the base image.

### Setup and Usage
See the included man page.

### Notes
- You cannot start a snapshot while the base is running.
- You can start the base after a snapshot is started.
