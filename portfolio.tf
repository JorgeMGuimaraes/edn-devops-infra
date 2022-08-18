## Official Ubuntu AMI ##
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

provider "aws" {
  profile = "default"
  region  = var.default_region
}

## EC2 instances ##
# vpc: vpc-032215522f09a469a
# subnet: subnet-0c3b7bae52c2ee3c0
#sg: sg-0b93b58396bac7247
module "web_app" {
  source                    = "./modules/ec2"
  instance_ami              = data.aws_ami.ubuntu.id
  instance_type             = var.instance_type
  instance_root_device_size = 8
  subnet                    = "subnet-0c3b7bae52c2ee3c0"
  security_groups           = ["sg-0b93b58396bac7247"]
  user_data                 = file("./modules/ec2/httpd.sh")
  # key_pair                  = file("./portfolio.pem")
}