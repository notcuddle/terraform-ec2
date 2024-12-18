output "ec2_instance_id" {
  value = aws_instance.web.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.web.public_dns
}