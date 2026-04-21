output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "control_node_public_ip" {
  value = aws_instance.control_node.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}
