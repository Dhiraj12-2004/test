terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/25"
}
resource "aws_route_table" "R1" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = "R1"
  }
}

resource "aws_subnet" "S1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "S1"
  }
}

resource "aws_subnet" "S2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.64/26"

  tags = {
    Name = "S2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.S1.id
  route_table_id = aws_route_table.R1.id
}


resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.S2.id
  route_table_id = aws_route_table.R1.id
}

resource "aws_route_table_association" "c" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.R1.id
}

resource "aws_instance" "example" {
  ami           = "ami-03695d52f0d883f65"
  subnet_id     = aws_subnet.S1.id
  instance_type = "t3.micro"
  key_name      = "linuxkp"
  #vpc_security_group_ids = ["sg-07862ec3d9b439e15"]
  tags = {
    Name = "TerraServer"
  }
}