output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "cluster_arn" {
  value = aws_eks_cluster.cluster.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "fargate_profile_arn" {
  value = aws_eks_fargate_profile.fargate_profile.arn
}
