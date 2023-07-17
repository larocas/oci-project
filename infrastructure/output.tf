# Output the public IP address of the load balancer
output "load_balancer_ip" {
  value = oci_load_balancer_load_balancer.appserver_lb.ip_address_details.0.ip_address
}

# Output the public IP address of the load balancer
output "grafana_load_balancer_ip" {
  value = oci_load_balancer_load_balancer.grafana_lb.ip_address_details.0.ip_address
}

# Output the public IP address of the load balancer
output "prometheus_load_balancer_ip" {
  value = oci_load_balancer_load_balancer.prometheus_lb.ip_address_details.0.ip_address
}

# Output the public IP address of the load balancer
output "bastion_ip" {
  value = oci_core_instance.bastion_instance.public_ip
}

# Output the public IP address of the load balancer
output "webserver_private_ip" {
  value = oci_core_instance.appserver_instance.private_ip
}

# # Output the public IP address of the load balancer
# output "grafana_public_ip" {
#   value = oci_core_instance.grafana_instance.public_ip
# }