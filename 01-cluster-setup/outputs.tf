output "ips" {
  value = {
    for cluster in module.student_cluster :
    cluster.name => {
      "control_plane_ipv4" = cluster.control_plane_ipv4
      "control_plane_ipv6" = cluster.control_plane_ipv6
      "worker1_ipv4"       = cluster.worker1_ipv4
      "worker1_ipv6"       = cluster.worker1_ipv6
      "worker2_ipv4"       = cluster.worker2_ipv4
      "worker2_ipv6"       = cluster.worker2_ipv6
    }
  }
  description = "The node IPs"
}
