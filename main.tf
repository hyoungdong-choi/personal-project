module "webpage-s3" {
  source        = "./modules/s3"
  bucket_name   = "jaewonflight-webpage-bucket-0000"
  html_file_path = "/home/ubuntu/terraform/project-2/webpage/"
  css_file_path = "/home/ubuntu/terraform/project-2/webpage/"
  allowed_origin = "https://www.it-is-what-it-is.site"
}

module "cloud_infra" {
  source = "./modules/cloud-infra"

  providers = {
    aws = aws
    aws.us-east-1 = aws.us-east-1
  }

  domain_name                = "it-is-what-it-is.site"
  alternative_names          = ["www.it-is-what-it-is.site"]
  provider_region            = "us-east-1"
  s3_bucket_domain_name      = module.webpage-s3.bucket_domain_name
  cloudfront_cache_policy_name = "Managed-CachingOptimized"
  default_root_object        = "main.html"
}

module "project-vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  private_subnets_cidr = [ "10.0.1.0/24", "10.0.2.0/24" ]
  availability_zones = [ "ap-northeast-2a", "ap-northeast-2c" ]
}

module "dynamodb_flightlist_info" {
  source        = "./modules/dynamodb/flightlist_db"
  
  table_name    = "Flightlist_Info"
  hash_key_name = "FlightNumber"
  hash_key_type = "S" # String 타입

  tags          = {
    Environment = "project-Flightlist"
  }
}

module "s3_bucket_policy" {
  source = "./modules/policy"

  // S3 Webpage bucket policy
  web_bucket_name              = module.webpage-s3.bucket_name
  web_bucket_arn               = module.webpage-s3.bucket_arn
  aws_account_id               = var.aws_account_id
  cloudfront_distribution_id   = module.cloud_infra.cloudfront_distribution_id

  // Flightlist Lambda policy
  dynamodb_table_arn = module.dynamodb_flightlist_info.dynamodb_table_arn
  s3_bucket_arn = module.webpage-s3.bucket_arn
}

module "roles" {
  source = "./modules/roles"

  flightlist_policy_arn = module.s3_bucket_policy.flightlist_policy_arn
}

module "flightlist_lambdas" {
  source = "./modules/lambdas/flightlist_lambda"

  function_name = "flightlist_lambda"
  runtime = "nodejs16.x"
  handler = "index.handler"
  role_arn = module.roles.project_flightlist_role_arn
  source_dir = "./api-lambda/"
}

module "api-gateway-1" {
  source = "./modules/api-gateway/api-gateway-1"
  
  region = "ap-northeast-2"
  api_name = "project-api-1"
  flightlist_lambda_arn = module.flightlist_lambdas.flightlist_lambda_function_arn
  stage_name = "project-api-gateway-1"
}

module "rds" {
  source = "./modules/rds" # RDS 모듈의 경로

  # RDS 모듈에 필요한 변수들을 VPC 모듈의 출력을 사용하여 여기에 전달합니다.
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.36"
  instance_identifier    = "my-db-instance"
  username               = "admin"
  password               = "dkagh1.dkagh1."
  multi_az               = false
  storage_type           = "gp2"
  vpc_security_group_ids = [module.project-vpc.rds_security_group_id]
  db_subnet_group_name   = module.project-vpc.rds_subnet_group_name
}