# Bastion Security Group 
resource "oci_core_network_security_group" "bastion_security_group" {
    compartment_id = var.tenancy_ocid
    vcn_id = oci_core_vcn.bastion_vcn.id
    display_name = "BastionSG"
}

resource "oci_core_network_security_group_security_rule" "bastion_security_rule" {
  network_security_group_id = oci_core_network_security_group.bastion_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  source                    = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
        min = 22
        max = 22
    }
}
}

resource "oci_core_network_security_group_security_rule" "bastion_security_rule_egress" {
  network_security_group_id = oci_core_network_security_group.bastion_security_group.id
  direction                 = "EGRESS"
  protocol                  = "6"  # TCP
  destination                    = "0.0.0.0/0"
}

resource "oci_core_network_security_group" "webserver_security_group" {
    compartment_id = var.tenancy_ocid
    vcn_id = oci_core_vcn.vcn.id
    display_name = "WebServerSG"
}

# Web Server Security Group 
resource "oci_core_network_security_group_security_rule" "web_security_rule" {
  network_security_group_id = oci_core_network_security_group.webserver_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  # source                    = var.subnet_cidr_block
  source =  oci_core_network_security_group.loadbalancer_security_group.id
  tcp_options {
    destination_port_range {
        min = 8080
        max = 8080
    }
}
}

resource "oci_core_network_security_group_security_rule" "grafana_security_rule" {
  network_security_group_id = oci_core_network_security_group.webserver_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  source                    = oci_core_network_security_group.loadbalancer_security_group.id
  tcp_options {
    destination_port_range {
        min = 3000
        max = 3000
    }
}
}

resource "oci_core_network_security_group_security_rule" "prometheu_security_rule" {
  network_security_group_id = oci_core_network_security_group.webserver_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  source                    = oci_core_network_security_group.loadbalancer_security_group.id
  tcp_options {
    destination_port_range {
        min = 9090
        max = 9090
    }
}
}

resource "oci_core_network_security_group_security_rule" "ssh_security_rule" {
  network_security_group_id = oci_core_network_security_group.webserver_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  source                    = "${var.bastion_vcn_cidr_block}"
  tcp_options {
    destination_port_range {
        min = 22
        max = 22
    }
}
}

resource "oci_core_network_security_group_security_rule" "web_security_rule_egress" {
  network_security_group_id = oci_core_network_security_group.webserver_security_group.id
  direction                 = "EGRESS"
  protocol                  = "6"  # TCP
  destination                    = "0.0.0.0/0"
}

resource "oci_core_network_security_group" "loadbalancer_security_group" {
    compartment_id = var.tenancy_ocid
    vcn_id = oci_core_vcn.vcn.id
    display_name = "LoadBalancerSG"
}

resource "oci_core_network_security_group_security_rule" "lb_security_rule_egress" {
  network_security_group_id = oci_core_network_security_group.loadbalancer_security_group.id
  direction                 = "EGRESS"
  protocol                  = "6"  # TCP
  destination                    = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "lb_security_rule" {
  network_security_group_id = oci_core_network_security_group.loadbalancer_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"  # TCP
  source                    = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
        min = 80
        max = 80
    }
}
}

# resource "oci_core_network_security_group" "grafana_security_group" {
#     compartment_id = var.tenancy_ocid
#     vcn_id = oci_core_vcn.vcn.id
#     display_name = "BastionSG"
# }

# resource "oci_core_network_security_group_security_rule" "grafana_security_rule" {
#   network_security_group_id = oci_core_network_security_group.grafana_security_group.id
#   direction                 = "INGRESS"
#   protocol                  = "6"  # TCP
#   source                    = "0.0.0.0/0"
#   tcp_options {
#     destination_port_range {
#         min = 80
#         max = 80
#     }
# }
# }

# resource "oci_core_network_security_group_security_rule" "grafana_security_rule_egress" {
#   network_security_group_id = oci_core_network_security_group.grafana_security_group.id
#   direction                 = "EGRESS"
#   protocol                  = "6"  # TCP
#   destination                    = "0.0.0.0/0"
# }