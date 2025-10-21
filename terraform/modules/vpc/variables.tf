variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for subnet tagging"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}
