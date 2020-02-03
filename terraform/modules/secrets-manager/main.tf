

resource "aws_iam_user" "secrets_manager" {
  name = "secrets-manager"
}

resource "aws_iam_user_policy" "secrets_manager" {
  name = "secrets-manager"
  user = "${aws_iam_user.secrets_manager.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": "secretsmanager:*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "kms:*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:Get*",
            "s3:List*"
        ],
        "Resource": "arn:aws:s3:::k8s-lime-config/*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "arn:aws:s3:::lime-secrets-backup/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "secrets_backup" {
  bucket = "lime-secrets-backup"
  acl    = "private"
  tags = {
    Name = "lime-secrets-backup"
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "secrets_backup" {
  bucket = "${aws_s3_bucket.secrets_backup.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "deny-except",
      "Effect": "Deny",
      "NotPrincipal": {
          "AWS": [
              "arn:aws:iam::167290662341:user/nick",
              "arn:aws:iam::167290662341:user/secrets-manager"
          ]
      },
      "Action": [
          "s3:*"
      ],
      "Resource": [
          "arn:aws:s3:::lime-secrets-backup/*"
        ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "secrets_manager_user_access" {
  name = "secret-managers-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": "secretsmanager:*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "kms:*",
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "secrets_manager" {
  name = "secrets-manager-s3-backup-user-access"
  path = "/"
  description = "Allow users to access the secrets backup in s3"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "arn:aws:s3:::lime-secrets-backup/*"
    }
  ]
}
EOF
}