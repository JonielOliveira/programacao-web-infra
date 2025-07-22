# Define as tags padrão utilizadas em todos os recursos da aplicação
locals {
  default_tags = {
    Project     = "join-and-chat"
    Environment = "universal"
    Owner       = "joniel"
    ManagedBy   = "terraform"
  }
}

# Cria o Security Group com regras para liberar SSH, HTTP e HTTPS
resource "aws_security_group" "joinchat_sg" {
  name        = "joinchat-sg"
  description = "Permitir SSH, HTTP e HTTPS"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Name    = "joinchat-sg"
    Purpose = "security-group"
  })
}

# Cria a instância EC2 que hospeda o frontend, backend e banco de dados
resource "aws_instance" "joinchat_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.joinchat_sg.name]

  tags = merge(local.default_tags, {
    Name    = "joinchat-ec2"
    Purpose = "application-host"
  })
}

# Cria um Elastic IP
resource "aws_eip" "joinchat_eip" {
  tags = merge(local.default_tags, {
    Name    = "joinchat-eip"
    Purpose = "static-ip"
  })
}

# Associa o EIP à instância EC2
resource "aws_eip_association" "joinchat_eip_assoc" {
  instance_id   = aws_instance.joinchat_instance.id
  allocation_id = aws_eip.joinchat_eip.id
}

# Cria a zona hospedada no Route 53
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(local.default_tags, {
    Name    = "joinchat-zone"
    Purpose = "dns-zone"
  })
}

# Registro DNS para o frontend: chat.joniel.dev.br
resource "aws_route53_record" "chat_frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "chat.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.joinchat_eip.public_ip]
}

# Registro DNS para o backend: api.chat.joniel.dev.br
resource "aws_route53_record" "chat_backend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.chat.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.joinchat_eip.public_ip]
}