

# Get your public IP for SSH access
# data "http" "my_ip" {
#   url = "https://checkip.amazonaws.com/"
# }

# Create VPC with 2 public subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "devopsforu-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  tags = {
    Name = "devopsforu-vpc"
  }
}

# Security group allowing SSH from your IP
resource "aws_security_group" "ssh_access" {
  name        = "allow-ssh"
  description = "Allow SSH from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    cidr_blocks = ["0.0.0.0/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

# Launch EC2 using exact GitHub source for v4.3.0 (safe version)
module "ec2_instance" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance?ref=v4.3.0"

  name                        = "devopsforu-ec2"
  ami                         = "ami-0e7f9c9fced6cfb10" # ✅ Amazon Linux 3 AMI in me-southeast-1
  instance_type               = "t3.micro"
  key_name                    = "dfu2025-key"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true

  tags = {
    Name = "devopsforu-ec2"
    Env  = "Dev"

  }
}
