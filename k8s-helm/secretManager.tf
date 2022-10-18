resource "aws_secretsmanager_secret" "DB_Secrets" {
  name = "database/MySQL"
}

# import the user data from AWS as Data source
data "aws_iam_user" "user" {
  user_name = "Nico"
}

resource "aws_secretsmanager_secret_policy" "DB_Secrets" {
  secret_arn = aws_secretsmanager_secret.DB_Secrets.arn
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "EnableAnotherAWSAccountToReadTheSecret",
        "Effect": "Allow",
        "Principal": {
          "AWS": [data.aws_iam_user.user.arn]
        },
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "*"
      }
    ]
  })
}

# The map here can come from other supported configurations
# like locals, resource attribute, map() built-in, etc.
variable "DB_Secrets" {
  default = {
    DB_IP         = "34.159.3.127"
    DB_USER       = "pexon-training"
    DB_PASSWORD   = "pexon-training2022gatekeeper"
    DB_NAME       = "books"
  }
  type = map(string)
}

resource "aws_secretsmanager_secret_version" "DB_Secrets" {
  secret_id     = aws_secretsmanager_secret.DB_Secrets.id
  secret_string = jsonencode(var.DB_Secrets)
}

