resource "aws_lb" "app" {
  name = var.app_name
  internal = var.internal
  load_balancer_type = "application"
  security_groups = [var.security_groups]
  subnets = var.alb_subnets
  access_logs {
    bucket = var.bucket_name
    prefix = "${var.app_name}-alb-logs"
    enabled = true
  }
}

resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port = "80"
  protocol = "HTTP"
    default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.combined.arn
  }
}

resource "aws_lb_target_group" "combined" {
  name_prefix = var.name_initials
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check{
	matcher = "200-299"
    protocol = "HTTP"
    port = "80"
		path = "/Home"
	}
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "combineda" {
  target_group_arn = aws_lb_target_group.combined.arn
  target_id = var.ec2a_instance
  port = 80
}