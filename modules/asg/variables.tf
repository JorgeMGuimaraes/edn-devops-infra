variable "instance_ami" {
  type        = string
  description = "Image to use"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 size"
}

variable "az" {
  type        = string
  description = "Valid subnet to assign"
}

variable "user_data" {
  type        = string
  description = "Post install script"
}

variable "public_key" {
  type        = string
  description = "Permission ssh public key"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "Security groups to assign"
}

variable "subnet" {
  type        = string
  description = "Valid subnet to assign"
}