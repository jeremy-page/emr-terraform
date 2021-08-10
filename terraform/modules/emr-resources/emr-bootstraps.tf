## EMR Bootstrap scripts
# Creates file containing SSH keys for developers
data "template_file" "dev_ssh_keys" {
  template = file("${path.module}/templates/dev-ssh-keys.txt.tpl")
}
# TODO: change _dev_ to _developer_ - very confusing
resource "aws_s3_bucket_object" "dev_ssh_keys_s3" {
  key                    = "config/common/dev_ssh_keys.txt"
  bucket                 = var.ingress_bucket_name
  server_side_encryption = "aws:kms"
  content                = data.template_file.dev_ssh_keys.rendered
}

data "template_file" "emr_bootstrap" {
  template = file("${path.module}/templates/emr_bootstrap.sh.tpl")

  vars = {
    env                 = var.environment
    ingress_bucket_name = var.ingress_bucket_name
  }
}

resource "aws_s3_bucket_object" "emr_bootstrap_file" {
  key                    = "config/common/emr_bootstrap.sh"
  bucket                 = var.ingress_bucket_name
  server_side_encryption = "aws:kms"
  content                = data.template_file.emr_bootstrap.rendered
}
