# Desafio 7 Terraform EC2

Este repositorio tiene como finalidad el poder desplegar una infraestructura en AWS utilizando terraform. Lo que vamos a realizar es crear una instancia EC2 con un servidor nginx que muestre un sitio web estatico. La forma en la cual vamos a acceder va hacer por medio de un CDN en este caso utilizamos CloudFront.

## Tabla de Contenidos
- [Requisitos](#requisitos)
- [Creacion archivo principal]()
- [Uso](#uso)
- [Contribuciones](#contribuciones)


### Requisitos
Vamos a tener que tener instalados los siguente software para poder realizar este proyecto
- Terraform CLI [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS CLI [Install aws](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Creacion archivo principal
Creamos un archivo main.tf donde vamos a colocar el proevedor a utilizar (en este caso AWS) colocamos lo siguente en el archivo

```bash
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```
Con esto le estamos diciendo a terraform el proevedor a utilizar y cual va hacer la region donde va a desplegar los recursos.

### Creacion de VPC y Subnet
Creamos dos archivos ahora con el nombre vpc.tf. Aca vamos a dejar todos los recursos de red que vamos a utilizar. Pegamos lo siguente

```bash
# Crear la VPC
resource "aws_vpc" "vpc-web-nginx" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Crear la subred pública
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc-web-nginx.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

```
Con esto ya tenemos nuestra vpc y subnet

### Creacion Grupo de seguridad para Instancia EC2
Ahora creamos el grupo que nos va a permitir que el contenido de nuestro servidor solo puedan ingresar trafico HTTP y SSH.

```bash
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22       
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80       
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }


  tags = {
    Name = "servidor-web-sg"
  }
}
```