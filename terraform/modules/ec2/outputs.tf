output "instance_id" {
  value = aws_instance.student_ec2.id
}

output "public_ip" {
  value = aws_instance.student_ec2.public_ip
}

output "elastic_ip" {
  value = aws_eip.student_eip.public_ip
}