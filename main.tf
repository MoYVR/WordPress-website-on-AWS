terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

# VPC

resource "aws_vpc" "main" {
  cidr_block  =  "10.0.0.0/16"

}

# Public Subnet 1&2

locals {
  public_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
}

resource "aws_subnet" "public" {

    count = 2

    vpc_id      = aws_vpc.main.id
    cidr_block  = local.public_cidr[count.index]

    tags =  {
      name = "Public${count.index}"
    }
 }

# Private Subnet 1&2

locals {
  private_cidr = ["10.0.2.0/24", "10.0.3.0/24"]
}

resource "aws_subnet" "private" {

    count = 2

    vpc_id      = aws_vpc.main.id
    cidr_block  = local.private_cidr[count.index]

    tags =  {
      name = "private${count.index}"
    }
 }

# Gatewat

resource "aws_internet_gateway" "main" {
     vpc_id  = aws_vpc.main.id
      tags = {
         name = "main"
     }
 }

# Elastic IP for NAT

resource "aws_eip"  "nat" {
    count = 2
    vpc = true
 }

# NAT

resource "aws_nat_gateway" "main" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "main"
  }
}

# Public Routing Table

resource "aws_route_table" "public" {
    vpc_id  = aws_vpc.main.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main.id
    }
  tags = {
        name = "public"
    }   
}

# Private Routing Table

resource "aws_route_table" "private" {
    count = 2
    vpc_id  = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.main[count.index].id
  }
  tags = {
        name = "private${count.index}"
    }   
}