#Network
resource "aws_internet_gateway" "igw" {
  vpc_id = var.create_new_vpc == true ? aws_vpc.vpc-main[0].id : data.aws_vpc.exist-vpc[0].id
}
resource "aws_default_route_table" "rt_subnet" {
  default_route_table_id = aws_vpc.vpc-main[0].default_route_table_id

  route {
    cidr_block = var.ip_saida_internet_gateway
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_vpc" "vpc-main" {
  count      = var.create_new_vpc == true ? 1 : 0
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" : var.vpc_name
  }
}
resource "aws_subnet" "vm-subnet-1" {
  count = var.create_new_subnet == true ? 1 : 0

  vpc_id            = var.create_new_vpc == false ? data.aws_vpc.exist-vpc[0].id : aws_vpc.vpc-main[0].id
  cidr_block        = cidrsubnet(var.create_new_vpc == false ? data.aws_vpc.exist-vpc[0].cidr_block : aws_vpc.vpc-main[0].cidr_block, 4, 1)
  availability_zone = var.availability_zones_1
  tags = {
    "Name" : var.subnet_name
  }

  depends_on = [aws_vpc.vpc-main, data.aws_vpc.exist-vpc]
}
resource "aws_subnet" "vm-subnet-2" {
  count = var.create_new_subnet == true ? 1 : 0

  vpc_id            = var.create_new_vpc == false ? data.aws_vpc.exist-vpc[0].id : aws_vpc.vpc-main[0].id
  cidr_block        = cidrsubnet(var.create_new_vpc == false ? data.aws_vpc.exist-vpc[0].cidr_block : aws_vpc.vpc-main[0].cidr_block, 4, 2)
  availability_zone = var.availability_zones_2
  tags = {
    "Name" : var.subnet_name
  }

  depends_on = [aws_vpc.vpc-main, data.aws_vpc.exist-vpc]
}
data "aws_vpc" "exist-vpc" {
  count = var.create_new_vpc == false ? 1 : 0

  id = var.vpc_id
}
data "aws_subnet" "exist-subnet" {
  count = var.create_new_vpc == 0 ? 1 : 0

  vpc_id     = var.create_new_vpc == true ? aws_vpc.vpc-main[0].id : data.aws_vpc.exist-vpc[0].id
  cidr_block = var.exists_subnet_cidr_block

  depends_on = [aws_vpc.vpc-main, data.aws_vpc.exist-vpc]
}
data "aws_ami" "choose_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = var.filter_ami_name
    values = var.architecture_type_ami
  }
}

resource "aws_security_group" "vm-sg" {
  name   = "sg_vm"
  vpc_id = var.create_new_vpc == false ? data.aws_vpc.exist-vpc[0].id : aws_vpc.vpc-main[0].id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.vm-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.vm-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#VM
resource "aws_instance" "vm-instance" {
  count                       = var.vm_count
  ami                         = data.aws_ami.choose_ami.id
  key_name                    = aws_key_pair.keypair.key_name
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip ? true : false
  availability_zone           = var.availability_zones_1
  subnet_id                   = var.create_new_subnet == true ? aws_subnet.vm-subnet-1[0].id : data.aws_subnet.exist-subnet[0].id
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids      = [aws_security_group.vm-sg.id]

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    systemctl start amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    EOF
  tags = {
    "Name" : "my-vm-${var.project_name}"
  }
  depends_on = [aws_vpc.vpc-main, data.aws_vpc.exist-vpc, aws_subnet.vm-subnet-1[0], aws_subnet.vm-subnet-2[0], data.aws_subnet.exist-subnet, aws_security_group.vm-sg]
}
#ssm for vm
resource "aws_iam_role" "ssm_role" {
  name               = "ssm_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}
resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

#vm key
resource "aws_key_pair" "keypair" {
  key_name   = "keypair-${var.project_name}"
  public_key = var.public_key
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key_pair" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/${aws_key_pair.keypair.key_name}.pem"
}
