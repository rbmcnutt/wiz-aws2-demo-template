
variable "my_ip_address" {
  type = string
  default = "###.###.###.###/32" # Use google to "find my ip addresss" Yse the IPv4 format with /32 for the mask
}

variable "my_bucket_name" {
  type = string
default = "wizdemo9999"  # Must be globally unique in AWS
}

variable "my_ssh_public_key"{
  type = string
  default = "ENTER_STRING_HERE" # Use a secure string. Do not check this file into the repo.
