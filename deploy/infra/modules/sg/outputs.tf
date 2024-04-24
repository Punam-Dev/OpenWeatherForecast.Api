output "app_sg" {
  value = aws_security_group.app-sg.id
}

output "alb_sg" {
  value = aws_security_group.openweatherforecast-alb-sg.id
}