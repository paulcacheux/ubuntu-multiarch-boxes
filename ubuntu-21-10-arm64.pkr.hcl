variable "qemu_config" {
  default = {
    headless : true,
    accelerator : null,
    display : null
    qemuargs : null
  }
}

source "qemu" "ubuntu2110-arm64-libvirt" {
  vm_name                = "ubuntu2110-arm64-libvirt"
  output_directory       = "output/ubuntu2110-arm64-libvirt"
  boot_wait              = "10s"
  boot_keygroup_interval = "1s"
  boot_command = [
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
    "c<wait10>",
    "set gfxpayload=keep<enter><wait10>",
    "linux /casper/vmlinuz autoinstall quiet net.ifnames=0 biosdevname=0 ",
    "ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu2110.vagrant.\" --- <enter><wait10>",
    "initrd /casper/initrd<enter><wait10>",
    "boot<enter>",
  ]
  format             = "qcow2"
  disk_size          = "131072"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_cache         = "unsafe"
  disk_image         = false
  disk_compression   = true
  disk_interface     = "virtio-scsi"
  net_device         = "virtio-net"
  cpus               = 2
  memory             = 2048
  http_directory     = "http"

  headless    = var.qemu_config.headless
  accelerator = var.qemu_config.accelerator
  display     = var.qemu_config.display
  qemuargs    = var.qemu_config.qemuargs

  iso_url                = "https://mirrors.kernel.org/ubuntu-releases/21.10/ubuntu-21.10-live-server-amd64.iso"
  iso_checksum           = "sha256:e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"
  ssh_username           = "root"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_timeout            = "3h"
  ssh_handshake_attempts = "20"
  shutdown_command       = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.ubuntu2110-arm64-libvirt"]

  provisioner "shell" {
    scripts = [
      "scripts/fixkvp.sh",
      "scripts/vagrant.sh",
      "scripts/qemu.sh",
    ]
    timeout             = "120m"
    start_retry_timeout = "15m"
    expect_disconnect   = "true"
  }
}
