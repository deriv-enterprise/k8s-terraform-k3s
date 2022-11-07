
locals {
  workers_arm64_medium = templatefile("${path.module}/init/worker.tftpl", {
    k3s_token_for_demo = random_uuid.insecure_master_token.result,
    k3s_private_ip     = aws_instance.master.private_ip,
    labels = {
      "nodePool" = "arm64_medium"
      "arch"     = "arm64"
    }
  })
}

resource "aws_instance" "workers_arm64_medium" {
  count         = 1
  ami           = data.aws_ami.debian_arm64.id
  instance_type = "t4g.medium"
  user_data     = local.workers_arm64_medium
  key_name      = aws_key_pair.master.key_name
  monitoring    = true

  subnet_id              = data.aws_subnet.master.id
  vpc_security_group_ids = [aws_security_group.master.id]
}


output "workers_arm64_public_ip" {
  value = aws_instance.workers_arm64_medium[*].public_ip
}

output "workers_arm64_private_ip" {
  value = aws_instance.workers_arm64_medium[*].private_ip
}
