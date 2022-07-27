terraform {
  required_version = ">= 1.0"

  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-develop"
    }
  }
}

variable "account_id" {
  type    = string
  default = "acc-svrcncgh453bi8g"
}
variable "prefix" {
  type    = string
  default = "master"
}
variable "scalr_token" {
  type = string
}
variable "scalr_hostname" {
  type = string
}


# resource "scalr_provider_configuration" "scalr" {
#   name                   = "scalr"
#   account_id             = var.account_id
#   export_shell_variables = false
#   environments           = ["*"]
#   scalr {
#     token    = var.scalr_token
#     hostname = var.scalr_hostname
#   }
# }
# resource "scalr_environment" "scalrpcfgtest" {
#   name                    = "pcfg-test-${var.prefix}"
#   account_id              = var.account_id
#   cost_estimation_enabled = false
# }

resource "scalr_vcs_provider" "vcs" {
  name = "git-aprrr"
  account_id = var.account_id
  # environment_id = local.environment_id
  vcs_type = "github"
  token = "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"
}

# resource "scalr_workspace" "scalrpcfgtest" {
#   name              = "workspace-pcfg-test-${var.prefix}"
#   environment_id    = scalr_environment.scalrpcfgtest.id
#   auto_apply        = false
#   operations        = false
#   vcs_provider_id   = scalr_vcs_provider.vcs.id
#   working_directory = "scalr_pcfg_create_workspace"
#   vcs_repo {
#     identifier = "ostasyuk/test-github-app"
#     path  = "null"
#     branch     = "master"
#   }

#   provider_configuration {
#     id = scalr_provider_configuration.scalr.id
#   }
# }

# resource "scalr_variable" "prefix" {
#   key            = "prefix"
#   value          = "${var.prefix}_slave"
#   category       = "terraform"
#   environment_id = scalr_environment.scalrpcfgtest.id
#   workspace_id   = scalr_workspace.scalrpcfgtest.id
# }

# resource "scalr_variable" "scalr_token" {
#   key            = "scalr_token"
#   value          = var.scalr_token
#   category       = "terraform"
#   environment_id = scalr_environment.scalrpcfgtest.id
#   workspace_id   = scalr_workspace.scalrpcfgtest.id
# }

# resource "scalr_variable" "scalr_hostname" {
#   key            = "scalr_hostname"
#   value          = var.scalr_hostname
#   category       = "terraform"
#   environment_id = scalr_environment.scalrpcfgtest.id
#   workspace_id   = scalr_workspace.scalrpcfgtest.id
# }
