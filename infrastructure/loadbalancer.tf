# Web Server Load balancer
resource "oci_load_balancer_load_balancer" "appserver_lb" {
  display_name     = "AppServerLoadBalancer"
  compartment_id   = var.tenancy_ocid
  shape            = "100Mbps"
  subnet_ids       = [oci_core_subnet.public_subnet_2.id, oci_core_subnet.public_subnet.id]
  network_security_group_ids = [oci_core_network_security_group.loadbalancer_security_group.id]
}


resource "oci_load_balancer_listener" "appserver_listener" {
  load_balancer_id = oci_load_balancer_load_balancer.appserver_lb.id
  name             = "AppServerListener"
  default_backend_set_name = oci_load_balancer_backend_set.appserver_backend_set.name
  port             = 80
  protocol = "HTTP"
}

resource "oci_load_balancer_backend_set" "appserver_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.appserver_lb.id
  name             = "AppServerBackendSet"
  policy           = "ROUND_ROBIN"
  health_checker {
    protocol = "HTTP"
    url_path = "/hello-world"
    port = 8080
  }
}

resource "oci_load_balancer_backend" "appserver_backend" {
  backendset_name = "AppServerBackendSet"
  port               = 8080
  load_balancer_id = oci_load_balancer_load_balancer.appserver_lb.id
  ip_address = oci_core_instance.appserver_instance.private_ip
}

# Grafana Load balancer backend
resource "oci_load_balancer_backend_set" "grafana_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.grafana_lb.id
  name             = "GrafanaBackendSet"
  policy           = "ROUND_ROBIN"
  health_checker {
    protocol = "HTTP"
    url_path = "/healthz"
    port = 3000
  }
}

resource "oci_load_balancer_backend" "grafana_backend" {
  backendset_name = "GrafanaBackendSet"
  port               = 3000
  load_balancer_id = oci_load_balancer_load_balancer.grafana_lb.id
  ip_address = oci_core_instance.appserver_instance.private_ip
}

resource "oci_load_balancer_load_balancer" "grafana_lb" {
  display_name     = "GrafanaLoadBalancer"
  compartment_id   = var.tenancy_ocid
  shape            = "100Mbps"
  subnet_ids       = [oci_core_subnet.public_subnet_2.id, oci_core_subnet.public_subnet.id]
  network_security_group_ids = [oci_core_network_security_group.loadbalancer_security_group.id]
}

resource "oci_load_balancer_listener" "grafana_listener" {
  load_balancer_id = oci_load_balancer_load_balancer.grafana_lb.id
  name             = "GrafanaListener"
  default_backend_set_name = oci_load_balancer_backend_set.grafana_backend_set.name
  port             = 80
  protocol = "HTTP"
}


# Prometheus balancer backend
resource "oci_load_balancer_backend_set" "prometheus_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.prometheus_lb.id
  name             = "PrometheusBackendSet"
  policy           = "ROUND_ROBIN"
  health_checker {
    interval_ms = 3000
    timeout_in_millis   = 2000
    protocol = "HTTP"
    url_path = "/graph"
    port = 9090
  }
}

resource "oci_load_balancer_backend" "prometheus_backend" {
  backendset_name = "PrometheusBackendSet"
  port               = 9090
  load_balancer_id = oci_load_balancer_load_balancer.prometheus_lb.id
  ip_address = oci_core_instance.appserver_instance.private_ip
}

resource "oci_load_balancer_load_balancer" "prometheus_lb" {
  display_name     = "PrometheusLoadBalancer"
  compartment_id   = var.tenancy_ocid
  shape            = "100Mbps"
  subnet_ids       = [oci_core_subnet.public_subnet_2.id, oci_core_subnet.public_subnet.id]
  network_security_group_ids = [oci_core_network_security_group.loadbalancer_security_group.id]
}

resource "oci_load_balancer_listener" "prometheus_listener" {
  load_balancer_id = oci_load_balancer_load_balancer.prometheus_lb.id
  name             = "PrometheusListener"
  default_backend_set_name = oci_load_balancer_backend_set.prometheus_backend_set.name
  port             = 80
  protocol = "HTTP"
}