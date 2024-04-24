resource "aws_security_group" "app-sg" {
  name = "${var.app_name}-SG"
  vpc_id = var.vpc_id  
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    # if cidr block is not commented then api can be accessed by ec2ip also
    # cidr_blocks = var.inbound_cidr
    security_groups = [aws_security_group.openweatherforecast-alb-sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "openweatherforecast-alb-sg" {
  name = "${var.app_name}-SG-alb"
  description = "${var.app_name} Alb HTTP"
  vpc_id      = var.vpc_id
  lifecycle {
      create_before_destroy = true
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = var.inbound_cidr
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}