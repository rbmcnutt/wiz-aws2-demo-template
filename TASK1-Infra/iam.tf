resource "aws_iam_role" "wizrole" {
  name = "WizRoleForMongoDB"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "wizpolicy" {
  name        = "WizAllowEC2All"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "wiz-attach" {
  role       = aws_iam_role.wizrole.name
  policy_arn = aws_iam_policy.wizpolicy.arn
}

resource "aws_iam_instance_profile" "mongo_profile" {
  name = "allow-mongo-ec2"
  role = aws_iam_role.wizrole.name
}