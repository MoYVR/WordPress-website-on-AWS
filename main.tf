terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Region

provider "aws" {
  region  = "us-east-1"
}

# VPC

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
}

# Public_Subnet 1&2

locals {
  public_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_cidr[count.index]

  tags = {
    Name = "Public${count.index}"
  }
}

# Private_Subnet 1&2

locals {
  private_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_cidr[count.index]

  tags = {
    Name = "private${count.index}"
  }
}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# EIP
resource "aws_eip" "nat" {
count = 2  
vpc                       = true
}



# NAT Gateway

resource "aws_nat_gateway" "main" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "gw NAT${count.index}"
  }

    depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  count = 2
  vpc_id = aws_vpc.main.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
    tags = {
    Name = "public${count.index}"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  count = 2
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.main[count.index].id
  }

    tags = {
    Name = "private${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_instance" "public" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  associate_public_ip_address  = true
  subnet_id  = aws_subnet.public.0.id
  key_name= "moz"

  tags = {
    Name = "Public"
  }
}

resource "aws_instance" "private" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  subnet_id  = aws_subnet.private.0.id
  key_name= "moz"


  tags = {
    Name = "Private"
  }
}

 