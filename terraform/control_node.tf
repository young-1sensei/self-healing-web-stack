resource "aws_instance" "control_node" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.control.id]
  iam_instance_profile        = aws_iam_instance_profile.control_node_profile.name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y git terraform ansible-core
              
              # Install AWS collection for Ansible
              ansible-galaxy collection install amazon.aws
              
              echo "Control Node is ready."
              EOF

  tags = {
    Name = "control-node"
  }
}
