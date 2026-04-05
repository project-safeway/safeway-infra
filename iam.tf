data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_ecr_pull_role" {
  count              = var.create_ec2_ecr_iam_resources ? 1 : 0
  name               = "safeway-ec2-ecr-pull-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_read_only" {
  count      = var.create_ec2_ecr_iam_resources ? 1 : 0
  role       = aws_iam_role.ec2_ecr_pull_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_ecr_pull_profile" {
  count = var.create_ec2_ecr_iam_resources ? 1 : 0
  name = "safeway-ec2-ecr-pull-profile"
  role = aws_iam_role.ec2_ecr_pull_role[0].name
}
