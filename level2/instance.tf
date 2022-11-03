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

# Private Security Group

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

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

