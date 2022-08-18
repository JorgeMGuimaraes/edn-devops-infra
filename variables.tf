variable "default_region" {
  type        = string
  default     = "sa-east-1"
  description = "The region this infrastructure is in"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 size"
}
