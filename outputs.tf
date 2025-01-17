locals {
  pkrvars_hcl = <<EOT
builder_vpc_id       = "${local.vpc_id}"
builder_subnet_id    = "${local.private_subnet_main_id}"
web_identity_assume_role_arn      = "${aws_iam_role.packer_gitlab.arn}"
iam_instance_profile = "${aws_iam_instance_profile.ssm_instance_core.id}"
aws_region           = "${data.aws_region.this.name}"
EOT

}

output "pkrvars_hcl" {
  value = local.pkrvars_hcl
}

output "pkrvars_hcl_b64" {
  value = base64encode(local.pkrvars_hcl)
}

output "instance_profile_id" {
  value       = aws_iam_instance_profile.ssm_instance_core.id
  description = "The instance profile id for the builder instances"
}

output "instance_profile_arn" {
  value       = aws_iam_instance_profile.ssm_instance_core.arn
  description = "The instance profile arn for the builder instances"
}

output "packer_gitlab_role_arn" {
  value       = aws_iam_role.packer_gitlab.arn
  description = "The ARN of the Packer role that can be assumed by the CI user"
}
