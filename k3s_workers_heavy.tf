
locals {
  worker_heavy_init = templatefile("${path.module}/init/worker.tftpl", {
    k3s_token_for_demo = random_uuid.insecure_master_token.result,
    k3s_private_ip     = aws_instance.master.private_ip,
    labels = {
      "nodePool" = "heavy"
    }
  })
}

# resource "null_resource" "diff" {
#   triggers = {
#     data = local.worker_init
#   }
# }

resource "aws_instance" "workers_heavy" {
  count         = 1
  ami           = data.aws_ami.debian.id
  instance_type = "t3.medium"
  user_data     = local.worker_heavy_init
  key_name      = aws_key_pair.master.key_name
  monitoring    = true

  subnet_id              = data.aws_subnet.master.id
  vpc_security_group_ids = [aws_security_group.master.id]
}


output "workers_heavy_public_ip" {
  value = aws_instance.workers_heavy[*].public_ip
}
