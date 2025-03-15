output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "instance_public_ips" {
  value = [
    aws_instance.web_1.public_ip,
    aws_instance.web_2.public_ip,
    aws_instance.web_3.public_ip
  ]
}