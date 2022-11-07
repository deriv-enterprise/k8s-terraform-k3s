
locals {
  worker_default_init = templatefile("${path.module}/init/worker.tftpl", {
    k3s_token_for_demo = random_uuid.insecure_master_token.result,
    k3s_private_ip     = aws_instance.master.private_ip,
    labels = {
      "nodePool" = "amd64_medium"
      "arch"     = "amd64"
    }
  })
}

resource "aws_instance" "workers_amd64_medium" {
  count         = 3
  ami           = data.aws_ami.debian_amd64.id
  instance_type = "t3.medium"
  user_data     = local.worker_default_init
  key_name      = aws_key_pair.master.key_name
  monitoring    = true

  subnet_id              = data.aws_subnet.master.id
  vpc_security_group_ids = [aws_security_group.master.id]
}


output "workers_amd64_public_ip" {
  value = aws_instance.workers_amd64_medium[*].public_ip
}

output "workers_amd64_private_ip" {
  value = aws_instance.workers_amd64_medium[*].private_ip
}
