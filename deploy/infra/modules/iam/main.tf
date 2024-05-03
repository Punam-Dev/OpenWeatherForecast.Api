resource "aws_iam_instance_profile" "app" {
  name = "${aws_iam_role.app.name}"
  role = "${aws_iam_role.app.name}"
  tags = {
    RoleType = "service"
  }
}

resource "aws_iam_role" "app" {
  name = "${var.app_name}-instance-profile"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    RoleType = "service"
  }
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2-alb" {
  name = "${var.app_name}-ec2-alb"
  role = aws_iam_role.app.id
  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CreateDeleteTags",
        "Effect": "Allow",
        "Action": [
          "ec2:DeleteTags",
          "ec2:CreateTags"
        ],
        "Resource": [
          "${var.ec2a_arn}"
        ]
      },
      {
        "Sid": "DescribeTags",
        "Effect": "Allow",
        "Action": "ec2:DescribeTags",
        "Resource": "arn:aws:ec2:*:*:instance/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2-s3" {
  name = "${var.app_name}-S3"
  role = aws_iam_role.app.id
  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssmmanagedinstancedefault-attach" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_iam_role_policy_attachment" "ssminstancecore-attach" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}