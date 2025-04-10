# Homelab

Contains mainly Config as Code and some code for my personal homelab.

![homelab servers - front](homelab.jpg "Homelab servers (front)")

![homelab servers - rear](homelab-rear.jpg "Homelab servers (not-so-neat rear)")

## Services
Many of the services running on my homelab can be found in this repo, organized by the VM they run on.
Not all services have CasC. Those that do mostly share the same standard setup: CoreOS initialized through a Butane config file. The main reasons for going with CoreOS is that it's immutable and auto updates, which is great for home services that aren't actively maintained.

## Hardware
Some specs:
- 5x Lenovo P330 Tiny (i7 8700T / 64GB RAM)
- 3 nodes have quad 2.5gbe PCIe cards
- 1 node (iSCSI host) has an 10gbe SFP card
- 1 node (AI workloads) has a NVIDIA RTX3050
- Ubiquiti Unifi Pro Max 16 switch