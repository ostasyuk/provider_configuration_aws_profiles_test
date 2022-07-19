# ------------- create aws user that can assume role that has permission to create and delete s3://<bucket_name>/obj1 (obj2) --------------
resource "random_string" "external_id" {
  length  = 10
  special = false
}


resource "aws_iam_user" "role_delegation_test" {
  name = "scal_aws_pcfg_role_delegation_test"
}

resource "aws_iam_access_key" "role_delegation_test" {
  user = aws_iam_user.role_delegation_test.name
}

resource "aws_iam_role" "role_delegation_test" {
  name = "scal_aws_pcfg_role_delegation_test"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.role_delegation_test.arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = random_string.external_id.id
          }
        }
      },
    ]
  })
  inline_policy {
    name = "allow_crud_obj1"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Effect = "Allow",
          Resource = [
            "arn:aws:s3:::${var.bucket_name}/obj1",
            "arn:aws:s3:::${var.bucket_name}/obj2",
          ]
        },
      ]
    })
  }
}

# ------------- provider configuration --------------
resource "scalr_provider_configuration" "rd" {
  name                   = "aws_obj1_obj2"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  aws {
    account_type        = "regular"
    credentials_type    = "role_delegation"
    access_key          = aws_iam_access_key.role_delegation_test.id
    secret_key          = aws_iam_access_key.role_delegation_test.secret
    role_arn            = aws_iam_role.role_delegation_test.arn
    external_id         = random_string.external_id.id
    trusted_entity_type = "aws_account"
  }
}


# ------------- create aws user that has permission to create and delete s3://<bucket_name>/obj3 (obj4) --------------

resource "aws_iam_user" "access_keys_test" {
  name = "scal_aws_pcfg_access_keys_test"
}

resource "aws_iam_access_key" "access_keys_test" {
  user = aws_iam_user.access_keys_test.name
}

resource "aws_iam_user_policy" "ak" {
  name = "access_keys_test"
  user = aws_iam_user.access_keys_test.name

  policy = <<EOF
{
  "Version": "2022-07-19",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}/obj3",
        "arn:aws:s3:::${var.bucket_name}/obj4",
      ]
    }
  ]
}
EOF
}

# ------------- provider configuration --------------
resource "scalr_provider_configuration" "ak" {
  name                   = "aws_obj3_obj4"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.access_keys_test.id
    secret_key       = aws_iam_access_key.access_keys_test.secret
  }
  depends_on = [
    aws_iam_user_policy.ak
  ]
}

# ----------------- workspaces
resource "scalr_environment" "test" {
  name                    = "pcfg-test"
  account_id              = var.account_id
  cost_estimation_enabled = false
  # default_provider_configuration = ["pcfg-1", "pcfg-2"]
}

data "scalr_vcs_provider" "test" {
  name       = "pcfg_test"
  account_id = var.account_id
}

resource "scalr_variable" "bucket_name" {
  key           = "bucket_name"
  value = var.bucket_name
  category     = "terraform"
  environment_id = scalr_environment.test.id
}


resource "scalr_workspace" "rd_v3" {
  name            = "workspace-pcfg-rd_v3"
  environment_id  = scalr_environment.test.id
  auto_apply      = false
  operations      = false
  vcs_provider_id = data.scalr_vcs_provider.test.id
  vcs_repo {
    identifier = "DayS1eeper/provider_configuration_aws_profiles_test/ws1_role_delegation_aws_v3"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.rd.id
  }
}
resource "scalr_workspace" "rd_v4" {
  name            = "workspace-pcfg-rd_v4"
  environment_id  = scalr_environment.test.id
  auto_apply      = false
  operations      = false
  vcs_provider_id = data.scalr_vcs_provider.test.id
  vcs_repo {
    identifier = "DayS1eeper/provider_configuration_aws_profiles_test/ws2_role_delegation_aws_v4"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.rd.id
  }
}

resource "scalr_workspace" "ak_v3" {
  name            = "workspace-pcfg-ak_v3"
  environment_id  = scalr_environment.test.id
  auto_apply      = false
  operations      = false
  vcs_provider_id = data.scalr_vcs_provider.test.id
  vcs_repo {
    identifier = "DayS1eeper/provider_configuration_aws_profiles_test/ws3_access_keys_aws_v3"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.ak.id
  }
}
resource "scalr_workspace" "ac_v3" {
  name            = "workspace-pcfg-ak_v4"
  environment_id  = scalr_environment.test.id
  auto_apply      = false
  operations      = false
  vcs_provider_id = data.scalr_vcs_provider.test.id
  vcs_repo {
    identifier = "DayS1eeper/provider_configuration_aws_profiles_test/ws4_access_keys_aws_v4"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.ak.id
  }
}