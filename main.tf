provider "aws" {
  default_tags {
    tags = module.this.tags
  }
}

data "aws_region" "this" {}

data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  enabled                = true
  availability_zones     = sort(slice(data.aws_availability_zones.this.names, 0, 2))
  default_az             = local.availability_zones[0]
  vpc_id                 = module.vpc[0].vpc_id
  private_subnet_main_id = module.subnets[0].az_private_subnets_map[local.default_az][0]
}

module "vpc" {
  source                           = "cloudposse/vpc/aws"
  version                          = "2.2.0"
  count                            = local.enabled ? 1 : 0
  ipv4_primary_cidr_block          = var.vpc_cidr
  assign_generated_ipv6_cidr_block = false
  context                          = module.this.context
  attributes                       = ["vpc"]
}

module "subnets" {
  source                          = "cloudposse/dynamic-subnets/aws"
  version                         = "2.4.2"
  count                           = local.enabled ? 1 : 0
  availability_zones              = local.availability_zones
  vpc_id                          = local.vpc_id
  igw_id                          = [module.vpc[0].igw_id]
  ipv4_cidr_block                 = [var.subnets_cidr]
  ipv6_enabled                    = false
  ipv4_enabled                    = true
  public_subnets_additional_tags  = { "Visibility" : "Public" }
  private_subnets_additional_tags = { "Visibility" : "Private" }
  metadata_http_endpoint_enabled  = true
  metadata_http_tokens_required   = true
  nat_gateway_enabled             = true
  max_nats                        = 1
  max_subnet_count                = 1
  context                         = module.this.context
  attributes                      = ["vpc", "subnet"]
}

data "aws_iam_policy_document" "packer_role_policy" {
  statement {
    # required for the aws packer plugin to work
    # https://developer.hashicorp.com/packer/integrations/hashicorp/amazon#iam-task-or-instance-role
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ssm:StartSession",
      "ssm:TerminateSession"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "iam:GetInstanceProfile",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "packer" {
  name               = "${module.this.id}-packer"
  assume_role_policy = data.aws_iam_policy_document.packer_assume_role.json
  tags               = module.this.tags
}

resource "aws_iam_role_policy" "packer" {
  name   = "${module.this.id}-PackerBuildPolicy"
  role   = aws_iam_role.packer.id
  policy = data.aws_iam_policy_document.packer_role_policy.json
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_instance_core" {
  name               = module.this.id
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_instance_core" {
  role       = aws_iam_role.ssm_instance_core.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

# this is the instance profile that the packer builds will use
resource "aws_iam_instance_profile" "ssm_instance_core" {
  name = module.this.id
  role = aws_iam_role.ssm_instance_core.name
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# now we need to create an IAM user that will be used in the gitlab ci pipeline to run the builds
resource "aws_iam_user" "ci" {
  name = "${module.this.id}-deploy"
  tags = module.this.tags
}

data "aws_iam_policy_document" "packer_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.ci.arn]
    }
  }
}
data "aws_iam_policy_document" "ci_user_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.packer.arn]
  }
}

resource "aws_iam_user_policy" "ci" {
  name   = module.this.id
  user   = aws_iam_user.ci.name
  policy = data.aws_iam_policy_document.ci_user_policy.json
}

resource "aws_iam_access_key" "ci_v1" {
  user   = aws_iam_user.ci.name
  status = "Active"
}
