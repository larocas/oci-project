# Virtual cloud network
resource "oci_core_vcn" "bastion_vcn" {
  cidr_block          = var.bastion_vcn_cidr_block
  display_name        = "BastionVCN"
  compartment_id      = var.tenancy_ocid
}

# Create a subnet for the bastion server
resource "oci_core_subnet" "bastion_subnet" {
  cidr_block          = var.bastion_subnet_cidr_block
  vcn_id              = oci_core_vcn.bastion_vcn.id
  display_name        = "BastionSubnet"
  compartment_id      = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  route_table_id = "${oci_core_route_table.bastion_route_table.id}"
  security_list_ids = [oci_core_security_list.bastion_security_list.id]
}

# Security list for the subnet
resource "oci_core_security_list" "bastion_security_list" {
  vcn_id        = oci_core_vcn.bastion_vcn.id
  display_name  = "BastionSecurityList"
  compartment_id = var.tenancy_ocid
  ingress_security_rules {
    protocol = "6"  # TCP
    source = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "all"  # All
  }
}

resource "oci_core_internet_gateway" "bastion_internet_gateway" {
  vcn_id              = oci_core_vcn.bastion_vcn.id
  compartment_id      = var.tenancy_ocid
}

resource "oci_core_route_table" "bastion_route_table" {
    vcn_id              = oci_core_vcn.bastion_vcn.id
    compartment_id      = var.tenancy_ocid
    route_rules {
        destination = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.bastion_internet_gateway.id
    }
    route_rules {
    destination  = "${var.vcn_cidr_block}"
    network_entity_id = oci_core_local_peering_gateway.bastion_local_peering_gateway.id
  }
}

resource "oci_core_route_table_attachment" "bastion_route_table_attachment" {
  subnet_id = oci_core_subnet.bastion_subnet.id
  route_table_id = oci_core_route_table.bastion_route_table.id
}

resource "oci_core_local_peering_gateway" "bastion_local_peering_gateway" {
    vcn_id              = oci_core_vcn.bastion_vcn.id
    compartment_id      = var.tenancy_ocid
    peer_id = oci_core_local_peering_gateway.local_peering_gateway.id
    # route_table_id = oci_core_route_table.route_table.id
}