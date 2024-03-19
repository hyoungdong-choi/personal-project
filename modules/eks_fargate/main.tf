resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role

  depends_on = [aws_cloudwatch_log_group.example]
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids = var.private_subnet
    endpoint_private_access = true  # VPC 내부에서만 클러스터 엔드포인트에 접근
    endpoint_public_access  = false  # VPC 외부에서도 클러스터 엔드포인트에 접근 불가
  }

  version = var.cluster_version
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = var.fargate_role
  subnet_ids             = var.private_subnet

  dynamic "selector" {
    for_each = var.fargate_profile_selector_namespace
    content {
      namespace = selector.value
    }
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.16.0-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.29.0-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.6"
  resolve_conflicts_on_update = "OVERWRITE"
}

# `aws-auth` ConfigMap 설정을 통해 클러스터에 사용자 추가
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
    aws_eks_cluster.cluster,
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.cluster_role
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:masters"]
      },
      # 다른 필요한 IAM 역할을 여기에 추가할 수 있습니다.
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Cho"
        username = "Cho"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Kim"
        username = "Kim"
        groups   = ["system:masters"]
      }
      # 추가 사용자를 여기에 계속 추가할 수 있습니다.
    ])
  }
}

data "aws_caller_identity" "current" {}


