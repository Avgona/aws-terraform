output "aws_availability_zones_names" {
  value       = data.aws_availability_zones.availability.names
  description = "AWS availability zone names"
}

output "latest_ubuntu_ami_name_id" {
  value = data.aws_ami.latest_ubuntu_ami_id.id
}

output "latest_ubuntu_ami_id_name" {
  value = data.aws_ami.latest_ubuntu_ami_id.name
}