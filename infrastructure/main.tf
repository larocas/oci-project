provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  region               = var.region
}

data "oci_identity_availability_domains" "ADs" {
    compartment_id = "${var.tenancy_ocid}"
}

# data "oci_core_instance" "test_instance" {
#     #Required
#     instance_id = "ocid1.instance.oc1.iad.anuwcljtgdxeylaczhh2vcgpawhv7rfowoysb3fomhzp6jpxz6zicwhrsbla"
# }