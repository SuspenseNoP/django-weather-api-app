variable "aws_region" {
  description = "AWS region to deploy resources"
  type = string
}

variable "ec2_instance" {
  description = "EC2 inctance name"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
}

variable "key_name" {
  description = "SSH key name"
  type = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}
variable "sg_name" {
  description = "VPC name"
  type        = string
}


