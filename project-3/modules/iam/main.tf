resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_fargate_pod_execution_role" {
  name = "eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_policy" {
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

# EKS와 Fargate 파드가 CloudWatch 로그를 생성하고, X-Ray와 같은 서비스와 통합할 수 있도록 추가 권한을 부여합니다.
resource "aws_iam_policy" "eks_additional_policies" {
  name        = "eks-additional-policies"
  description = "Extra permissions for EKS and Fargate integration with other AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "xray:PutTelemetryRecords",
          "xray:PutTraceSegments",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*",
        Effect = "Allow"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::project-flightlist-log-bucket",
          "arn:aws:s3:::project-flightlist-log-bucket/*"
        ],
        Effect = "Allow"
      }
      # 추가 필요한 IAM 권한을 여기에 추가합니다.
    ],
  })
}

resource "aws_iam_role_policy_attachment" "eks_additional_policies_attachment" {
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
  policy_arn = aws_iam_policy.eks_additional_policies.arn
}

resource "aws_s3_bucket" "eks_bucket" {
  bucket = "project-flightlist-log-bucket" # 고유한 이름으로 변경해야 합니다.

  tags = {
    Name        = "My EKS Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_ownership_controls" "eks_bucket_ownership_controls" {
  bucket = aws_s3_bucket.eks_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "eks_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.eks_bucket_ownership_controls]


  bucket = aws_s3_bucket.eks_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "eks_bucket_policy" {
  bucket = aws_s3_bucket.eks_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ],
        Resource = [
          "${aws_s3_bucket.eks_bucket.arn}",
          "${aws_s3_bucket.eks_bucket.arn}/*",
        ],
        Effect = "Allow",
        Principal = {
          AWS = [
            "${aws_iam_role.eks_cluster_role.arn}",
            "${aws_iam_role.eks_fargate_pod_execution_role.arn}",
          ]
        }
      }
    ]
  })
}


