packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.9"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "app" {
  region        = var.aws_region
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  ami_name = "${var.app_name}-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  tags = {
    Application = var.app_name
    BuildBy     = "packer"
  }
}
