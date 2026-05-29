provider "aws" {
  region     = "us-east-1"
  access_key = "ASIA2PHZA5GDDDZKWU2I"
  secret_key = "8r0EDAgJsj6M7olzYnbDtVK306zcx0/2m2bP7kk6"
  token      = "IQoJb3JpZ211X2VjE0////////////wEaCXVzLXdlc3QtMiJHMEUCIQDQ9qtxsQndyIAPSUhyEs1KGovgOd/wpYrq4dontB0QKAIGTONDMIDsPWaIcRJWyNP2hdzCrWLo3gAmg5yDxvfxZ2UqrAIIuP//////////ARAAGgw3MTk5MjkNzI3MTAiDNYbcR0Ay4SP+PZBpSqAAltKJMmxg44H0Kmt71jLt60nBU6J0JubYWAb7mmXP1EapH05tvUyBskTspuEKB/I/mfHoKuy/wzEqnoB7I96+BJ8BOfDzHD09xQA8Cvo5pc2yn9HzQffkAoAyCzCEKuW8d9dtka7vVPCm0AusKlXf1feL0y9TrW1Mrcy+InMCLF2T42AsrXCBQbvTeMWstrxV9t7Scgdx+M+1PE57n05YoKv5U8nmNVPKMd+vTkZ8gK5CvfXaZSv0gkXmnfom1R8nG7i0Pa8r5KJyDgGudiViXAH7Ke++VS67aaOnXBNX5wF8s600fpeB+rb1o9zZQJoQrqjmPsoz68o11Q8MxZRkw8pHj0AY6nQGU508RvkNr00T8/B3s44pIFup5bVXumkDESqAQvn1LK+N64zv6BTMODetngRuMdqBEXa8NzkXrofEbQwi5HK/9HRFRFi5GU5102mG/PrhcfRIy2qiCGa3bOyc5/ZMsQq3huvinQ6mYwOFClcXuhfbfWbxyXaaHXBKMNj6p0eGKvsE02Kdr6Wc0glS58MtGwdB5kOILs3x3B3K2u16"
}

resource "aws_vpc" "vpc_proyecto" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-Proyecto-Telematica"
  }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.vpc_proyecto.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Subnet-Publica-Proyecto"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_proyecto.id
  tags = {
    Name = "IGW-Proyecto"
  }
}

resource "aws_route_table" "rt_publica" {
  vpc_id = aws_vpc.vpc_proyecto.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_publica" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.rt_publica.id
}

resource "aws_security_group" "sg_web" {
  name        = "sg_proyecto_final"
  description = "Permitir trafico SSH y Web"
  vpc_id      = aws_vpc.vpc_proyecto.id

  ingress {
    description = "Acceso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir contenedor en puerto 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acceso HTTP Web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "servidor_web" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_publica.id
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  key_name               = "vockey"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.dist/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io
              sudo systemctl enable docker
              sudo systemctl start docker
              
              sudo mkdir -p /usr/local/lib/docker/cli-plugins/
              sudo curl -SL "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
              sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
              
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Servidor-Produccion-Telematica"
  }
}

output "ip_publica_servidor" {
  value       = aws_instance.servidor_web.public_ip
  description = "IP publica para acceder a la app"
}
