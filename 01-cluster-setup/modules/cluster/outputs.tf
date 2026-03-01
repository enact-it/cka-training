output "control_plane_ipv4" {
  value       = hcloud_server.control_plane.ipv4_address
  description = "The control plane ipv4 address"
}

output "control_plane_ipv6" {
  value       = hcloud_server.control_plane.ipv6_address
  description = "The control plane ipv6 address"
}

output "worker1_ipv4" {
  value       = hcloud_server.worker1.ipv4_address
  description = "The worker 1 ipv4 address"
}

output "worker1_ipv6" {
  value       = hcloud_server.worker1.ipv6_address
  description = "The worker 1 ipv6 address"
}

output "worker2_ipv4" {
  value       = hcloud_server.worker2.ipv4_address
  description = "The worker 2 ipv4 address"
}

output "worker2_ipv6" {
  value       = hcloud_server.worker2.ipv6_address
  description = "The worker 2 ipv6 address"
}

output "name" {
  value       = var.name
  description = "The name"
}
