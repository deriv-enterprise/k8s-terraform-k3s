resource "random_uuid" "insecure_master_token" {}

locals {
  master_init = templatefile("${path.module}/init/master.tftpl", {
    k3s_token_for_demo = random_uuid.insecure_master_token.result
  })
}


resource "aws_instance" "master" {
  ami           = data.aws_ami.debian_amd64.id
  instance_type = "t3.medium"
  user_data     = local.master_init
  key_name      = aws_key_pair.master.key_name
  monitoring    = true

  subnet_id              = data.aws_subnet.master.id
  vpc_security_group_ids = [aws_security_group.master.id]
}


output "master_public_ip" {
  value = aws_instance.master.public_ip
}
output "master_private_ip" {
  value = aws_instance.master.private_ip
}
