# EC2 Data Source
data "aws_ami" "ec2" {

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  most_recent = true
  owners      = ["amazon"]

  tags = {
    Name = "${var.env_code}-EC2"
  }
}

output "ec2_ami" {
  value = data.aws_ami.ec2
}

# Public EC2

resource "aws_instance" "public" {
  ami                         = data.aws_ami.ec2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[0]
  key_name                    = "main"
  vpc_security_group_ids      = [aws_security_group.public.id]

  tags = {
    Name = "${var.env_code}-Public"
  }
}

# Private EC2

resource "aws_instance" "private" {
  ami                    = data.aws_ami.ec2.id
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.level1.outputs.private_subnet_id[0]
  user_data              = file("user-data.sh")
  key_name               = "main"
  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "${var.env_code}-Private"
  }
}

# Public Security Group

resource "aws_security_group" "public" {
  name        = "${var.env_code}-public"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["96.49.56.42/32"]
  }


  ingress {
    description = "HTTP from public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["96.49.56.42/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-public"
  }
}

# Private Security Group

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description     = "HTTP from load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-private"
  }
}
