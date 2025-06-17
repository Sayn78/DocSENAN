  GNU nano 7.2                               main.tf                                        terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.1.10:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "exchg@03"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "vm_web" {
  name        = "web-vm"
  target_node = "proxmox"
  vmid        = 200
  clone       = "ubuntu-cloudinit-template"
  cores       = 2
  memory      = 4096

  disk {
    size        = "20G"
    type        = "scsi"
    storage     = "local-lvm"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  os_type = "cloud-init"

  ipconfig0 = "ip=192.168.1.200/24,gw=192.168.1.1"

  sshkeys = file("~/.ssh/id_ed25519.pub")
  ciuser = "senan"
  cipassword = "exchg@03"
}


