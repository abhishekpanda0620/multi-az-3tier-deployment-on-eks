variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "multi-az-3tier-eks"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
