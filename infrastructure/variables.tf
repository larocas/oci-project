variable "tenancy_ocid" {
  description = "The OCID of your tenancy."
}

variable "user_ocid" {
  description = "The OCID of your user."
}

variable "fingerprint" {
  description = "The fingerprint of your API signing key."
}

variable "private_key_path" {
  description = "The path to your private key file."
}

variable "region" {
  description = "The region where resources will be created."
  default = "us-ashburn-1"  
}

variable "vcn_cidr_block" {
  description = "The CIDR block for the VCN."
  default = "10.0.0.0/16" 
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  default = "10.0.0.0/24" 
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  default = "10.0.1.0/24" 
}

variable "public_subnet_cidr_block_2" {
  description = "The CIDR block for the subnet."
  default = "10.0.2.0/24" 
}

variable "availability_domain" {
  description = "The availability domain where resources will be created."
  default = "Ssmj:US-ASHBURN-AD-1"  
}

variable "bastion_vcn_cidr_block" {
  description = "The CIDR block for the VCN."
  default = "172.168.0.0/24" 
}

variable "bastion_subnet_cidr_block" {
  description = "The CIDR block for the bastion subnet."
  default     = "172.168.0.0/29"  
}

variable "instance_image" {
  description = "Instance image"
  default     = "ocid1.image.oc1.iad.aaaaaaaabsjwtwmwshxig7mfvopaidoupmuwlho7vab46zitunqiej33wh3a"
}

variable "instance_shape" {
  description = "Instance shape"
  default     = "VM.Standard.E2.1.Micro"  
}

variable "ssh_public_key" {
  description = "SSH Key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEnbxy2uL7mCLvxscGJGpcate6tiHfYIupRcB+GK5Tn3p1IkdZ6NXYoiWBqE68PRwJ7tOAjG+Ei690h5mzqrdg7oDbbPudtNHGJ1R9OHx2F5KmeQgT4qmJxezsIuMQvBeOtnngFbAjUtvv/bMD8KczBBcoDP7djxvlZjqT7KE9zI2AHyFY6Qjh6x57TfyzqTB8gNjiKCN66hwkS3tr3usmITLGWB6yAIHegn15OiZFqpSK0+JWOJ6tbI5JQZfTMWWJURAokAvHwQ9JAOpiVc8PWG+yil9M1GoAoiyhxOQBdaWrlwFa3V66izKKrvPqtRNBsgaOOnDPSE5CkW1++ger"
}
