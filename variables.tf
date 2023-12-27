variable "region" {
  description = "AWS region"
  default     = "ap-northeast-2"
}

variable "env" {
  description = "AWS env"
  default     = "dev"
}

variable "pjt" {
  description = "projcet name"
  default     = "mz"
}

variable "key_name" {
  description = "ssh key name"
  default     = "my_aws_key"
}

variable "my_vpc" {
  description = "vpc name"
  default     = "vpc-0166fa91f018c1728"
}

variable "my_port" {
  description = "port range"
  default = {
    sg_tcp_ports = [22, 80, 443, 8800, 7990, 7999, 4646, 4647, 4648],
    sg_udp_ports = [4646, 4647, 4648]
  }
}

variable "application_name" {
  description = "my name"
  default = "myweb"
}

variable "instance_type" {
  description = "instance_type"
  default = "t2.micro"
}

variable "ami" {
  description = "os image"
  default = "ami-027ce4ce0590e3c98"
}

variable "subnet" {
  description = "my subnet"
  default = "subnet-00d553b072fac7adc"
}

variable "no_of_instances" {
  description = "server no of instances"    
  default = "1"
}

