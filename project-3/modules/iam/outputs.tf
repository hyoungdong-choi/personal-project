output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster role."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_fargate_pod_execution_role_arn" {
  description = "The ARN of the EKS Fargate pod execution role."
  value       = aws_iam_role.eks_fargate_pod_execution_role.arn
}

output "eks_additional_policies_arn" {
  description = "The ARN of the additional IAM policy for EKS."
  value       = aws_iam_policy.eks_additional_policies.arn
}

output "s3_bucket_name" {
  description = "The name of the bucket used for storing EKS related data."
  value       = aws_s3_bucket.eks_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket used for storing EKS related data."
  value       = aws_s3_bucket.eks_bucket.arn
}

