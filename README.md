# Homelab

Contains mainly Config as Code and some code for my personal homelab.

![homelab servers - front](docs/homelab.jpg "Homelab servers (front)")

![homelab servers - rear](docs/homelab-rear.jpg "Homelab servers (not-so-neat rear)")

## Services
Many of the services running on my homelab can be found in this repo, organized by the VM they run on.
Not all services are set up using CasC. 

Most CasC services share the same standard setup: CoreOS initialized through a Butane config file. 
The main reasons for going with CoreOS is that it's immutable and auto updates, which is great for home services that aren't actively maintained.

I use Clevis and Tang to unlock LUKS encrypted drives, and to decrypt secrets. Clevis is a client that contacts a Tang service on the network to obtain decryption keys. This allows me to boot servers and VMs that use full disk encryption without having to manually enter passwords on boot. 

## Hardware
Some specs:
- 5x Lenovo P330 Tiny (i7 8700T / 64GB RAM)
- 3 nodes have quad 2.5gbe PCIe cards
- 1 node (iSCSI host) has an 10gbe SFP PCIe card
- 1 node (AI workloads) has a NVIDIA RTX3050 GPU
- Ubiquiti Unifi Pro Max 16 switch

## Creating ISOs for CoreOS based services
Each service is installed using a custom ISO that automatically installs the service to the VM. 
Create each ISO using, where `<service>` matches the name of the directory.
```
just build-coreos <service>
```

