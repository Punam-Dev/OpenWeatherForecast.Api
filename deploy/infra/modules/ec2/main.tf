resource "aws_instance" "ec2a" {
  subnet_id = var.subnet_id[0]
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [var.ec2_sg]
  iam_instance_profile = var.instance_profile
  # key_name = "Key-Pair-Mumbai-Machmain"
  availability_zone = "us-east-1a"
  user_data_base64 = "${base64encode(local.instance-userdata)}"
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 1
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdd"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.ec2a.id
}
