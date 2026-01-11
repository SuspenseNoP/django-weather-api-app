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

  provisioner "shell" {
    inline = [
      "mkdir -p /home/ubuntu/tmp"
    ]
  }

  #Files
  provisioner "file"{
    source = "../docker"
    destination = "/home/ubuntu/tmp"
  }

  provisioner "file"{
    source = "../.env"
    destination = "/home/ubuntu/tmp/.env"
  }

  provisioner "file"{
    source = "../scripts"
    destination = "/home/ubuntu/tmp"
  }

  provisioner "shell"{
    inline = [
      "sudo mkdir -p /opt/weather-app",
      "sudo cp -r /home/ubuntu/tmp/docker/* /opt/weather-app/",
      "sudo cp /home/ubuntu/tmp/.env /opt/weather-app/.env",

      "sudo cp /home/ubuntu/tmp/scripts/docker-compose-app.service /etc/systemd/system/weather-app.service",

      "sudo chown -R root:root /opt/weather-app",
      "sudo chmod 600 /opt/weather-app/.env",
      "sudo chmod 644 /etc/systemd/system/weather-app.service",

      "cd /opt/weather-app && sudo docker compose pull",

      "sudo systemctl daemon-reload",
      "sudo systemctl enable weather-app"
    ]
  }

}
