output "ec2_instance_public_ip" {
  description = "Public IP EC2"
  value       = module.ec2.public_ip
}

output "ec2_instance_private_ip" {
  description = "Privat IP EC2"
  value       = module.ec2.private_ip
}

output "ec2_instance_id" {
  description = "ID EC2"
  value       = module.ec2.id
}

output "ssh_key_name" {
  description = "SSH-key"
  value       = aws_key_pair.ssh_key.key_name
}

output "vpc_id" {
  description = "ID  VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets list"
  value       = module.vpc.public_subnets
}
