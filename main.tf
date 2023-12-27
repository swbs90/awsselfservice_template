provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  serverconfig = [
    for i in range(1, var.no_of_instances + 1) : {
      instance_name = "${var.application_name}-${i}"
      instance_type = var.instance_type
      subnet_id     = var.subnet
      ami           = var.ami
    }
  ]
}

locals {
  instances = flatten(local.serverconfig)
}

resource "aws_security_group" "mysg" {
  vpc_id = var.my_vpc
  name   = "application_name-sg"

  dynamic "ingress" {
    for_each = var.my_port.sg_tcp_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.my_port.sg_udp_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  for_each = { for server in local.instances : server.instance_name => server }

  key_name      = aws_key_pair.generated_key.key_name
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  associate_public_ip_address = true

  # private_ip    = each.value.private_ip

  vpc_security_group_ids = [
    aws_security_group.mysg.id
  ]

  # ebs_block_device {
  #   device_name = "/dev/sda1"
  #   volume_size = each.value.disk_size
  # }

  tags = {
    Name = "${each.value.instance_name}"
  }
}

# output "instances_ips" {
#   value = aws_instance.web.*.private_ip
# }

############   Create Bastion Host   ################
# resource "aws_security_group" "bastion-sg" {
#   name   = "11st-bastion"
#   vpc_id = var.my_vpc

#   ingress {
#     from_port   = 22
#     protocol    = "tcp"
#     to_port     = 22
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     "Name" = "11st-EKS-bastion-sg"
#   }
# }

# resource "aws_instance" "bastion" {
#   ami           = "ami-027ce4ce0590e3c98"
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-0b55f9d8ee318d75f"
#   key_name      = aws_key_pair.generated_key.key_name
#   vpc_security_group_ids = [
#     aws_security_group.bastion-sg.id
#   ]

#   tags = {
#     "Name" = "11st-EKS-bastionHost"
#   }
# }
# resource "aws_eip" "lb" {
#   instance = aws_instance.bastion.id
#   vpc      = true
# }
# output "bastion_eip" {
#   value = aws_eip.lb.public_ip
# }
