output "instance_id" {
  description = "ID da instância EC2 criada para o Join & Chat"
  value = aws_instance.joinchat_instance.id
}

output "instance_public_ip" {
  description = "IP público da EC2 (pode ser nulo se Elastic IP for usado)"
  value = aws_instance.joinchat_instance.public_ip
}

output "elastic_ip" {
  description = "IP público fixo (Elastic IP) da instância"
  value       = aws_eip.joinchat_eip.public_ip
}

output "route53_zone_id" {
  description = "ID da zona hospedada no Route 53"
  value       = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "Nameservers gerados pelo Route 53 para configuração no Registro.br"
  value       = aws_route53_zone.main.name_servers
}
