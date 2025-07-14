terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "django-tfstate-bucket"       
    key            = "terraform.tfstate"        
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"              
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs = ["eu-north-1a"]
  public_subnets = ["10.0.0.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.sg_name
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]

  ingress_with_cidr_blocks = [
  {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    description = "Django API"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = "0.0.0.0/0"
  }

]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = file(var.ssh_public_key_path)
}


module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.ec2_instance

  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.ssh_key.key_name
  monitoring    = false

  vpc_security_group_ids = [module.web_server_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e

              apt-get update -y
              apt-get install -y docker.io docker-compose

              systemctl enable docker
              systemctl start docker

              usermod -aG docker ubuntu
              EOF

  tags = {
    Terraform = "true"
  }
}


