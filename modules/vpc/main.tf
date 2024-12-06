resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = ""
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

 tags = {
    Name = ""
  }
}


resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.app_vpc.id

  count             = length(var.public_subnets_cidrs)
  cidr_block        = element(var.public_subnets_cidrs, count.index)
  availability_zone = element(var.aws_azs, count.index)

  map_public_ip_on_launch = true # This makes public subnet

  tags = {
    Name = ""
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = ""
  }
}


resource "aws_route_table_association" "public_rt_asso" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}