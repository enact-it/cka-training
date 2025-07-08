output "control_plane_ips" {
  value = {
    for cluster in module.student_cluster :
  cluster.name => { "ipv4" = cluster.control_plane_ipv4, "ipv6" = cluster.control_plane_ipv6 } }
  description = "The control plane IPs"
}
