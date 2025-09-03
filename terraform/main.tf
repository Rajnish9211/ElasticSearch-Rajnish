provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = "192.168.0.0/16"
  public_subnets = ["192.168.10.0/24", "192.168.20.0/24"]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

# -------------------- Ubuntu Instance --------------------
module "ubuntu_instance" {
  source           = "./modules/instances"
  ami_id           = "ami-0bbdd8c17ed981ef9" # Ubuntu 22.04
  instance_type    = "t3.large"              # upgraded from t2.medium
  key_name         = var.key_name
  public_subnet_id = module.networking.public_subnet_ids[0]
  public_sg_id     = module.security.public_sg_id
  name             = "elasticsearch-server"
  root_block_device = {
    volume_size = 50
    volume_type = "gp3"
  }
}

# -------------------- Amazon Linux Instance --------------------
module "amazonlinux_instance" {
  source           = "./modules/instances"
  ami_id           = "ami-00ca32bbc84273381" # Amazon Linux 2023
  instance_type    = "t3.large"              # upgraded from t2.medium
  key_name         = var.key_name
  public_subnet_id = module.networking.public_subnet_ids[1]
  public_sg_id     = module.security.public_sg_id
  name             = "amazon"
  root_block_device = {
    volume_size = 50
    volume_type = "gp3"
  }
}

#--------state running--------------------------
resource "aws_ec2_instance_state" "ubuntu_state" {
  instance_id = module.ubuntu_instance.instance_id
  state       = "running"
}

resource "aws_ec2_instance_state" "amazonlinux_state" {
  instance_id = module.amazonlinux_instance.instance_id
  state       = "running"
}

# -------------------- Outputs --------------------
output "ubuntu_public_ip" {
  value = module.ubuntu_instance.public_instance_ip
}

output "amazonlinux_public_ip" {
  value = module.amazonlinux_instance.public_instance_ip
}

output "ubuntu_fetch_name" {
  value = module.ubuntu_instance.fetch_name
}

output "amazonlinux_fetch_name" {
  value = module.amazonlinux_instance.fetch_name
}
