# Virtual cloud network
resource "oci_core_vcn" "vcn" {
  cidr_block          = var.vcn_cidr_block
  display_name        = "mainVCN"
  compartment_id      = var.tenancy_ocid
}

# Subnet
resource "oci_core_subnet" "private_subnet" {
  cidr_block          = var.subnet_cidr_block
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "PrivateSubnet"
  compartment_id      = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  route_table_id = "${oci_core_route_table.private_route_table.id}"
  security_list_ids = [oci_core_security_list.web_security_list.id]
}

# Subnet
resource "oci_core_subnet" "public_subnet" {
  cidr_block          = var.public_subnet_cidr_block
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "PublicSubnet"
  compartment_id      = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  route_table_id = "${oci_core_route_table.route_table.id}"
  security_list_ids = [oci_core_security_list.web_security_list.id]
}

# Subnet
resource "oci_core_subnet" "public_subnet_2" {
  cidr_block          = var.public_subnet_cidr_block_2
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "PublicSubnet2"
  compartment_id      = var.tenancy_ocid
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  route_table_id = "${oci_core_route_table.route_table.id}"
  security_list_ids = [oci_core_security_list.web_security_list.id]
}

# Security list for the subnet
resource "oci_core_security_list" "web_security_list" {
  vcn_id        = oci_core_vcn.vcn.id
  display_name  = "WebSecurityList"
  compartment_id = var.tenancy_ocid
  ingress_security_rules {
    protocol = "6"  
    source = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    protocol = "all"  
    source = "10.0.0.0/24"
  }
  ingress_security_rules {
    protocol = "6"  
    source = "${var.bastion_vcn_cidr_block}"
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "all"  
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id = var.tenancy_ocid
    vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "route_table" {
    vcn_id              = oci_core_vcn.vcn.id
    compartment_id      = var.tenancy_ocid
    route_rules {
        destination = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.internet_gateway.id
    }
    route_rules {
        destination = "${var.bastion_vcn_cidr_block}"
        network_entity_id = "${oci_core_local_peering_gateway.local_peering_gateway.id}"
  }
}

resource "oci_core_route_table_attachment" "route_table_attachment" {
  subnet_id = oci_core_subnet.public_subnet.id
  route_table_id =oci_core_route_table.route_table.id
}

resource "oci_core_route_table" "private_route_table" {
    vcn_id              = oci_core_vcn.vcn.id
    compartment_id      = var.tenancy_ocid
    route_rules {
        destination = "0.0.0.0/0"
        network_entity_id = oci_core_nat_gateway.nat_gateway.id
    }
    route_rules {
        destination = "${var.bastion_vcn_cidr_block}"
        network_entity_id = "${oci_core_local_peering_gateway.local_peering_gateway.id}"
  }
}

resource "oci_core_nat_gateway" "nat_gateway" {
    vcn_id              = oci_core_vcn.vcn.id
    compartment_id      = var.tenancy_ocid
}

resource "oci_core_route_table_attachment" "private_route_table_attachment" {
  subnet_id = oci_core_subnet.private_subnet.id
  route_table_id =oci_core_route_table.private_route_table.id
}

resource "oci_core_local_peering_gateway" "local_peering_gateway" {
    vcn_id              = oci_core_vcn.vcn.id
    compartment_id      = var.tenancy_ocid
}

