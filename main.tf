module "vpc" {
  source              = "./modules/vpc"
  cidr_block          = "10.10.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames= true
  vpc_name            = "MyVPC"
  public_subnets_cidr = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnets_cidr= ["10.10.3.0/24", "10.10.4.0/24"]
  availability_zones  = ["ap-northeast-2a", "ap-northeast-2c"]
  igw_name            = "MyIGW"
  enable_nat_gateway  = true
  region              = "ap-northeast-2"
}

module "iam" {
  source = "./modules/iam"
}

module "eks_fargate" {
  source                        = "./modules/eks_fargate"
  cluster_role = module.iam.eks_cluster_role_arn
  private_subnet = module.vpc.private_subnet_ids
  fargate_role = module.iam.eks_fargate_pod_execution_role_arn
  cluster_name                  = "my-eks-cluster"
  cluster_version               = "1.29"
  fargate_profile_name          = "my-fargate-profile"
  fargate_profile_selector_namespace = ["kube-system", "flightlist", "booking", "client"]
}