resource "tls_private_key" "secret" {
  algorithm = "ED25519"
}

resource "aws_secretsmanager_secret" "secret" {
  name = "training-keypair"
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    private_key = tls_private_key.secret.private_key_openssh
    public_key  = tls_private_key.secret.public_key_openssh
  })
}

resource "aws_key_pair" "generated_key" {
  key_name   = "training-key"
  public_key = tls_private_key.secret.public_key_openssh
}
