output "control_plane_ipv4" {
  value       = hcloud_server.control_plane.ipv4_address
  description = "The control plane ipv4 address"
}

output "control_plane_ipv6" {
  value       = hcloud_server.control_plane.ipv6_address
  description = "The control plane ipv6 address"
}

output "name" {
  value       = var.name
  description = "The name"
}
