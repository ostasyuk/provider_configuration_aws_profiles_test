provider "scalr" { }

resource "scalr_workspace" "vcs-driven" {
  name            = "my-workspace-name-new"
  environment_id  = "env-svrcnchebt61e30"
  execution_mode = "local"
}

# resource "null_resource" "env_varstimeo" {
#   count = 3
#   provisioner "local-exec" {
#     command = "echo $ENV"
#     environment = {
#       ENV = "Hello World"
#     }
#  }
# }
