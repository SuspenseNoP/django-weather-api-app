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

build {
  sources = ["source.amazon-ebs.app"]

  # Docker
  provisioner "shell"{
    script = "../scripts/install_docker.sh"
  }

  #App Files
  provisioner "file"{
    source = "../docker"
    destination = "/opt/weather-app"
  }

  provisioner "shell"{
    inline = [
      "cd /opt/weather-app",
      "docker compose pull"
    ]
  }

  provisioner "file"{
    source = "../scripts/docker-compose-app.service"
    destination = "/etc/systemd/system/weather-app.service"
  }

  provisioner "shell"{
    inline = [
      "systemctl daemon-reload",
      "systemctl enable weather-app "
    ]
  }

}
