data "http" "ipv4" {
  url = "http://ipecho.net/plain"
}

resource "hcloud_firewall" "fw" {
  name = "firewall"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "${data.http.ipv4.response_body}/32",
      "10.0.0.0/24"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "1-65535"
    source_ips = [
      "${data.http.ipv4.response_body}/32",
      "10.0.0.0/24"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "1-65535"
    source_ips = [
      "${data.http.ipv4.response_body}/32",
      "10.0.0.0/24"
    ]
  }
}


resource "hcloud_ssh_key" "key" {
  name       = var.name
  public_key = var.public_key
}

resource "tls_private_key" "node_key" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "node_key" {
  name       = "${var.name}-node-key"
  public_key = tls_private_key.node_key.public_key_openssh
}
