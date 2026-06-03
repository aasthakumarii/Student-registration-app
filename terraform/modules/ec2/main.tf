resource "aws_key_pair" "student_key" {

  key_name = var.key_name

  public_key = file("${path.root}/student-key.pub")
}

resource "aws_instance" "student_ec2" {

  ami = var.ami_id

  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile = var.instance_profile_name

  key_name = aws_key_pair.student_key.key_name

  user_data = file("${path.module}/userdata.sh")

  associate_public_ip_address = true

  tags = {
    Name = "student-app-server"
  }
}
resource "aws_eip" "student_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "student_eip_assoc" {
  instance_id   = aws_instance.student_ec2.id
  allocation_id = aws_eip.student_eip.id
}