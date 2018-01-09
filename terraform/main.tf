# Terraform simples com objetivo educacional, ele faz o básico que é levantar uma instancia
# utilizando ec2 da amazon, futuramente iremos separar o banco do ec2 e iremos colocar em um serviço 
# de rds separado, mas isso são cenas dos próximos capítulos.
# não iremos focar em orquestradores no momento, por isso a simplicidade da imagem que iremos gerar

# o provider é a chave de toda cadeia de recursos que invocamos  no terraform 
# nele dizemos qual produto iremos obter os recursos e invocamos recursos dela, 
# selecionamos a região us-east-1 da amazon por ter os preços mais bararos.
provider "aws" {
  region = "us-east-1"
}

# aqui buscamos a ami que geramos, detalhes pro filtro que vai pegar o mais recente
data "aws_ami" "single" {
  most_recent = true

  filter {
    name   = "name"
    values = ["deves/ubuntu-linux-lts-*"]
  }

  owners      = ["self"]
}

# iremos usar uma instancia simples em nosso projeto
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.single.id}"
  #Tipo da instancia
  instance_type = "t2.small"

  #Chave privada para logar na máquina por ssh se necessário
  key_name = "gerencio"

  tags {
    Name = "Discourse Machine"
  }

  vpc_security_group_ids = ["${aws_security_group.allow_basic.id}"]
}

# O security group são responsáveis pelas regras de segurança de acesso de sua instancia
# ele que age como se fosse um firewall e permite que exponhamos nosso serviço
resource "aws_security_group" "allow_basic" {
  name        = "allow_basic"
  description = "Allow basic inbound traffic"

  # liberar a porta http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh para manutencoes remotas (não desejamos isso pois trabalhamos com imutabilidade)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # regras de saída estão todas liberadas
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
