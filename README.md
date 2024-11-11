
<!-- markdownlint-disable -->
# terraform-aws-gitlab-runners
<!-- markdownlint-restore -->

<!-- [![README Header][readme_header_img]][readme_header_link] -->

[![The Guardian][logo]][website]

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform module to prepare an AWS account for building AMIs with packer.

---






It's 100% Open Source and licensed under the [GNU General Public License](LICENSE).









## Introduction

This Terraform module sets up the necessary AWS infrastructure to build AMIs using HashiCorp Packer in a GitLab CI pipeline. It creates a dedicated VPC with private subnets, IAM roles and policies for both the Packer builder instances and the CI pipeline user. The module implements AWS Systems Manager Session Manager for secure instance access and uses role assumption for enhanced security.

The module creates:
- A VPC with private subnets for building AMIs
- An IAM role for Packer with necessary EC2 and SSM permissions
- An instance profile with SSM access for builder instances
- A CI user with minimal permissions to assume the Packer role



## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.



```terraform
module "packer_pipeline" {
    source = "git::https://gitlab.com/guardianproject-ops/terraform-aws-packer-pipeline?ref=main"
    context = module.this.context
    vpc_cidr          = "10.0.128.0/24"
    subnets_cidr      = "10.0.128.0/26"
}
```






<!-- markdownlint-disable -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnets"></a> [subnets](#module\_subnets) | cloudposse/dynamic-subnets/aws | 2.4.2 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/vpc/aws | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.ci_v1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_instance_profile.ssm_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.packer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ssm_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.packer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssm_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ci_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.instance_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnets_cidr"></a> [subnets\_cidr](#input\_subnets\_cidr) | CIDR block for the subnets | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_user_access_key_id"></a> [iam\_user\_access\_key\_id](#output\_iam\_user\_access\_key\_id) | n/a |
| <a name="output_iam_user_secret_access_key"></a> [iam\_user\_secret\_access\_key](#output\_iam\_user\_secret\_access\_key) | n/a |
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | The instance profile arn for the builder instances |
| <a name="output_instance_profile_id"></a> [instance\_profile\_id](#output\_instance\_profile\_id) | The instance profile id for the builder instances |
| <a name="output_packer_role_arn"></a> [packer\_role\_arn](#output\_packer\_role\_arn) | The ARN of the Packer role that can be assumed by the CI user |
| <a name="output_pkrvars_hcl"></a> [pkrvars\_hcl](#output\_pkrvars\_hcl) | n/a |
| <a name="output_pkrvars_hcl_b64"></a> [pkrvars\_hcl\_b64](#output\_pkrvars\_hcl\_b64) | n/a |
<!-- markdownlint-restore -->




## Help

**Got a question?** We got answers.

File a GitLab [issue](https://gitlab.com/guardianproject-ops/terraform-aws-gitlab-runners/-/issues), send us an [email][email] or join our [Matrix Community][matrix].

## Matrix Community

[![Matrix badge](https://img.shields.io/badge/Matrix-%23guardianproject%3Amatrix.org-blueviolet)][matrix]

Join our [Open Source Community][matrix] on Matrix. It's **FREE** for everyone!
This is the best place to talk shop, ask questions, solicit feedback, and work
together as a community to build on our open source code.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://gitlab.com/guardianproject-ops/terraform-aws-gitlab-runners/-/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or help out with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitLab
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2021-2024 The Guardian Project










## License

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

```text
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```






## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [The Guardian Project][website].

[![The Guardian Project][logo]][website]

We're a [collective of designers, developers, and ops][website] folk focused on useable
privacy and security with a focus on digital human rights and humanitarian projects.

Everything we do is 100% FOSS.

Follow us on [Mastodon][mastodon] or [twitter][twitter], [apply for a job][join], or
[partner with us][partner].

We offer [paid support][contact] on all of our projects.

Check out [our other DevOps projects][gitlab] or our [entire other set of
projects][nonops] related to privacy and security related software, or [hire
us][website] to get support with using our projects.


## Contributors

<!-- markdownlint-disable -->
|  [![Abel Luck][abelxluck_avatar]][abelxluck_homepage]<br/>[Abel Luck][abelxluck_homepage] |
|---|
<!-- markdownlint-restore -->

  [abelxluck_homepage]: https://gitlab.com/abelxluck
  [abelxluck_avatar]: https://gitlab.com/uploads/-/system/user/avatar/941123/avatar.png?width=130

<!-- markdownlint-disable -->
  [website]: https://guardianproject.info/?utm_source=gitlab&utm_medium=readme&utm_campaign=guardianproject-ops/terraform-aws-gitlab-runners&utm_content=website
  [gitlab]: https://www.gitlab.com/guardianproject-ops
  [contact]: https://guardianproject.info/contact/
  [matrix]: https://matrix.to/#/%23guardianproject:matrix.org
  [readme_header_img]: https://gitlab.com/guardianproject/guardianprojectpublic/-/raw/master/Graphics/GuardianProject/pngs/logo-color-w256.png
  [readme_header_link]: https://guardianproject.info?utm_source=gitlab&utm_medium=readme&utm_campaign=guardianproject-ops/terraform-aws-gitlab-runners&utm_content=readme_header_link
  [readme_commercial_support_img]: https://www.sr2.uk/readme/paid-support.png
  [readme_commercial_support_link]: https://www.sr2.uk/?utm_source=gitlab&utm_medium=readme&utm_campaign=guardianproject-ops/terraform-aws-gitlab-runners&utm_content=readme_commercial_support_link
  [partner]: https://guardianproject.info/how-you-can-work-with-us/
  [nonops]: https://gitlab.com/guardianproject
  [mastodon]: https://social.librem.one/@guardianproject
  [twitter]: https://twitter.com/guardianproject
  [email]: mailto:support@guardianproject.info
  [join_email]: mailto:jobs@guardianproject.info
  [join]: https://guardianproject.info/contact/join/
  [logo_square]: https://assets.gitlab-static.net/uploads/-/system/group/avatar/3262938/guardianproject.png?width=88
  [logo]: https://gitlab.com/guardianproject/guardianprojectpublic/-/raw/master/Graphics/GuardianProject/pngs/logo-color-w256.png
  [logo_black]: https://gitlab.com/guardianproject/guardianprojectpublic/-/raw/master/Graphics/GuardianProject/pngs/logo-black-w256.png
  [cdr]: https://digiresilience.org
  [cdr-tech]: https://digiresilience.org/tech/
<!-- markdownlint-restore -->
