variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "public_subnet_id" {}
variable "public_sg_id" {}

variable "name" {
  description = "Name tag for EC2 instance"
  type        = string
}

variable "root_block_device" {
  type = map(any)
}