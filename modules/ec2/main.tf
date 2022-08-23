resource "aws_instance" "small_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.portfolio_key.key_name
  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp2"
  }

  subnet_id                   = var.subnet
  vpc_security_group_ids      = var.security_groups
  user_data                   = var.user_data
  associate_public_ip_address = true

  tags = {
    Name = var.server_name
  }
}

resource "aws_key_pair" "portfolio_key" {
  #key_name   = "aws_key"
  public_key = var.public_key
}
