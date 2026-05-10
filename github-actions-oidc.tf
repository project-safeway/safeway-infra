# GitHub Actions → AWS via OIDC. Em contas restritas (ex.: AWS Academy) isso costuma falhar
# (iam:CreateOpenIDConnectProvider / CreateRole). Use enable_github_actions_oidc = false e
# autentique o Actions com AWS_ACCESS_KEY_ID + AWS_SECRET_ACCESS_KEY (ver DEPLOY.md).

data "tls_certificate" "github_actions" {
  count = var.enable_github_actions_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.enable_github_actions_oidc ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions[0].certificates[0].sha1_fingerprint]
}

locals {
  github_actions_subjects = flatten([
    for repo in var.github_actions_repositories : [
      for branch in var.github_actions_branches : "repo:${repo}:ref:refs/heads/${branch}"
    ]
  ])
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  count = var.enable_github_actions_oidc ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = length(local.github_actions_subjects) > 0 ? local.github_actions_subjects : ["repo:__unset__/__unset__:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  count = var.enable_github_actions_oidc ? 1 : 0

  name               = var.github_actions_oidc_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role[0].json
}

data "aws_iam_policy_document" "github_actions_permissions" {
  count = var.enable_github_actions_oidc ? 1 : 0

  statement {
    sid       = "ECRAuth"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "ECRPushPull"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages"
    ]
    resources = [
      module.ecr.frontend_repository_arn,
      module.ecr.core_repository_arn,
      module.ecr.financial_repository_arn
    ]
  }

  statement {
    sid = "DescribeForDeploy"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SSMSendCommand"
    actions = [
      "ssm:SendCommand",
      "ssm:GetCommandInvocation",
      "ssm:ListCommandInvocations",
      "ssm:ListCommands"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions_inline" {
  count = var.enable_github_actions_oidc ? 1 : 0

  name   = "safeway-github-actions-inline"
  role   = aws_iam_role.github_actions[0].id
  policy = data.aws_iam_policy_document.github_actions_permissions[0].json
}
