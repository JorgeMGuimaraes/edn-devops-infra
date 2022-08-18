variable "instance_ami" {
  type        = string
  description = "Image to use"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 size"
}

variable "instance_root_device_size" {
  type        = number
  default     = 8
  description = "Root block size in GB"
}

variable "subnet" {
  type        = string
  description = "Valid subnet to assign"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "Security groups to assign"
}

variable "user_data" {
  type        = string
  description = "Post install script"
}

variable "key_pair" {
  type        = string
  description = "Permission ssh private key"
}