provider "yandex" {
  zone = var.zone_name
}

data "yandex_resourcemanager_folder" "folder" {
  name = var.folder_name
}

data "yandex_vpc_subnet" "subnet" {
  name      = var.subnet_name
  folder_id = data.yandex_resourcemanager_folder.folder.id
}

resource "yandex_compute_instance" "wg" {
  name        = var.instance_name
  platform_id = "standard-v2"
  zone        = var.zone_name
  folder_id   = data.yandex_resourcemanager_folder.folder.id

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = "10"
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "1"
    user-data          = file("./user-data.txt")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_dns_recordset" "dns" {
  zone_id = var.dns_zone_id
  name    = var.dns_instance_name
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.wg.network_interface.0.nat_ip_address}"]
}

