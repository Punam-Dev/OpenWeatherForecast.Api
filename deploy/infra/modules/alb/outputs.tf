output "elb_dns_name" {
  value = aws_lb.app.dns_name
}

output "elb_zone_id" {
  value = aws_lb.app.zone_id
}