# Web server
resource "oci_core_instance" "appserver_instance" {
  compartment_id         = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  shape                  = var.instance_shape

  source_details {
    source_id =  var.instance_image
    source_type = "image"
  }
  create_vnic_details {
    assign_public_ip      = false
    subnet_id = oci_core_subnet.private_subnet.id
    nsg_ids = [oci_core_network_security_group.webserver_security_group.id]
  }
  metadata = {
        ssh_authorized_keys = "${var.ssh_public_key}"
    }
}

# Create an instance for the bastion server
resource "oci_core_instance" "bastion_instance" {
  compartment_id         = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  shape                  = var.instance_shape
  create_vnic_details {
    subnet_id = oci_core_subnet.bastion_subnet.id
    nsg_ids = [oci_core_network_security_group.bastion_security_group.id]
  }
  source_details {
        source_id =  var.instance_image
        source_type = "image"
  }
  metadata = {
        ssh_authorized_keys = "${var.ssh_public_key}"
    }
}

# # Grafana server
# resource "oci_core_instance" "grafana_instance" {
#   compartment_id         = var.tenancy_ocid
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
#   shape                  = var.instance_shape

#   source_details {
#     source_id =  var.instance_image
#     source_type = "image"
#   }
#   create_vnic_details {
#     assign_public_ip      = true
#     subnet_id = oci_core_subnet.public_subnet_2.id
#     nsg_ids = [oci_core_network_security_group.grafana_security_group.id]
#   }
#   metadata = {
#         ssh_authorized_keys = "${var.ssh_public_key}"
#     }
# }