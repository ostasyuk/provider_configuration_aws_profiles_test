terraform {
  required_version = ">= 1.0"

  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-develop"
    }
  }
}

variable "acc1" {
  type    = string
  default = "acc-svrcncgh453bi8g"
}
variable "acc2" {
  type    = string
  default = "acc-t06njb731vvm94g"
}

resource "scalr_provider_configuration" "pcfg1" {
  name         = "test"
  account_id   = var.acc1
  environments = ["*"]
  custom {
    provider_name = "test"
    argument {
      name  = "name"
      value = "value"
    }
  }
}

resource "scalr_provider_configuration" "pcfg2" {
  name         = "test"
  account_id   = var.acc2
  environments = ["*"]
  custom {
    provider_name = "test"
    argument {
      name  = "name"
      value = "value"
    }
  }
}

data "scalr_provider_configuration" "pcfg1" {
  name       = "test"
  account_id = var.acc1
  depends_on = [
    scalr_provider_configuration.pcfg1,
    scalr_provider_configuration.pcfg2
  ]
}

data "scalr_provider_configuration" "pcfg2" {
  name       = "test"
  account_id = var.acc2
  depends_on = [
    scalr_provider_configuration.pcfg1,
    scalr_provider_configuration.pcfg2
  ]
}

data "scalr_provider_configurations" "pcfg1" {
  name       = "test"
  account_id = var.acc1
  depends_on = [
    scalr_provider_configuration.pcfg1,
    scalr_provider_configuration.pcfg2
  ]
}

data "scalr_provider_configurations" "pcfg2" {
  name       = "test"
  account_id = var.acc2
  depends_on = [
    scalr_provider_configuration.pcfg1,
    scalr_provider_configuration.pcfg2
  ]
}

output "pcfg1_id" {
  value = scalr_provider_configuration.pcfg1.id
}
output "pcfg1_id_from_data_source_single" {
  value = data.scalr_provider_configuration.pcfg1.id
}
output "pcfg1_id_from_data_source_list" {
  value = data.scalr_provider_configurations.pcfg1.ids
}

output "pcfg2_id" {
  value = scalr_provider_configuration.pcfg2.id
}
output "pcfg2_id_from_data_source_single" {
  value = data.scalr_provider_configuration.pcfg2.id
}
output "pcfg2_id_from_data_source_list" {
  value = data.scalr_provider_configurations.pcfg2.ids
}
