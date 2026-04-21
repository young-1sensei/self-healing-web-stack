resource "aws_iam_role" "control_node_role" {
  name = "control-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_readonly" {
  role       = aws_iam_role.control_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "control_node_profile" {
  name = "control-node-profile"
  role = aws_iam_role.control_node_role.name
}
