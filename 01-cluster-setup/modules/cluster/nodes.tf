resource "hcloud_server" "control_plane" {

  name         = "${var.name}-control-plane"
  image        = "ubuntu-24.04"
  server_type  = "cx22"
  location     = "fsn1"
  ssh_keys     = [hcloud_ssh_key.key.name]
  firewall_ids = [hcloud_firewall.fw.id]
  network {
    network_id = hcloud_network.cluster.id
    ip         = local.control_plane_ip
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname           = "control-plane"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
    node_key           = tls_private_key.node_key.public_key_openssh
  })
}

resource "hcloud_server" "worker1" {

  name        = "${var.name}-worker1"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  location    = "fsn1"

  ssh_keys     = [hcloud_ssh_key.key.name]
  firewall_ids = [hcloud_firewall.fw.id]
  network {
    network_id = hcloud_network.cluster.id
    ip         = local.worker1_ip
  }


  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname           = "worker1"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
    node_key           = tls_private_key.node_key.public_key_openssh
  })
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
}

resource "hcloud_server" "worker2" {

  name         = "${var.name}-worker2"
  image        = "ubuntu-24.04"
  server_type  = "cx22"
  location     = "fsn1"
  ssh_keys     = [hcloud_ssh_key.key.name]
  firewall_ids = [hcloud_firewall.fw.id]
  network {
    network_id = hcloud_network.cluster.id
    ip         = local.worker2_ip
  }
  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname           = "worker2"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
    node_key           = tls_private_key.node_key.public_key_openssh
  })

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
}
