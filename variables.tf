variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnets_cidr" {
  type        = string
  description = "CIDR block for the subnets"
}

variable "gitlab_tls_url" {
  type = string
  # Avoid using https scheme because the Hashicorp TLS provider has started following redirects starting v4.
  # See https://github.com/hashicorp/terraform-provider-tls/issues/249
  default = "tls://gitlab.com:443"
}

variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "oidc_gitlab_aud_value" {
  type    = string
  default = "https://gitlab.com"
}

variable "oidc_gitlab_match_field" {
  type    = string
  default = "sub"
}

variable "oidc_gitlab_match_value" {
  type = list(any)
}
