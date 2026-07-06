variable "aws_region" {
    default = "eu-north-1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    default = "10.0.1.0/24"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    description = "Name of the existing AWS key pair for SSH access"
    type = string
}