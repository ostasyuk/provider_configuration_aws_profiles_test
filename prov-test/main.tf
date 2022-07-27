provider "scalr" { }

resource "null_resource" "env_varstimeo" {
  count = 3
  provisioner "local-exec" {
    command = "echo $ENV"
    environment = {
      ENV = "Hello World"
    }
 }
}
