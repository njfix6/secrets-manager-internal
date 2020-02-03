
resource "aws_iam_policy" "secrets-manager-ci-pipeline" {
  name        = "secrets-manager-ci-pipeline"
  path        = "/"
  description = "Allowing the secrets manager pipeline to pull images from ECR, and read from Kops state store from S3."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ECR",
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": [
                "arn:aws:ecr:us-west-2:167290662341:repository/build-deploy"
            ]
        },
        {
            "Sid": "ECRAuthorizeAll",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}