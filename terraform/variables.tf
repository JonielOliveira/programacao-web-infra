variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID da Amazon Machine Image (AMI) a ser utilizada para a instância EC2"
  type        = string
  default     = "ami-034568121cfdea9c3" # Ubuntu Server (Noble Numbat) 24.04 LTS (na região us-east-1)
}

variable "instance_type" {
  description = "Tipo da instância EC2 (ex: t3.micro, t3.small, etc)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nome da chave SSH criada na AWS EC2"
  type        = string
}

variable "domain_name" {
  description = "Domínio que será usado para a aplicação"
  type        = string
}
