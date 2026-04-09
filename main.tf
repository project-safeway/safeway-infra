# ─── AMI Ubuntu 24.04 LTS (free tier) ─────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "ecr" {
  source = "./modules/ecr"

  frontend_repository_name  = var.frontend_ecr_repository_name
  core_repository_name      = var.core_ecr_repository_name
  financial_repository_name = var.financial_ecr_repository_name
  image_tag_mutability      = var.ecr_image_tag_mutability
  scan_on_push              = var.ecr_scan_on_push
  force_delete              = var.ecr_force_delete
}

locals {
  ec2_instance_profile_name = (
    var.create_ec2_ecr_iam_resources
    ? aws_iam_instance_profile.ec2_ecr_pull_profile[0].name
    : var.existing_ec2_instance_profile_name
  )

  frontend_user_data = templatefile("${path.module}/templates/frontend-user-data.sh.tftpl", {
    frontend_image = var.frontend_image
    ecr_registry   = local.ec2_instance_profile_name != null ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com" : ""
    aws_region     = data.aws_region.current.name
  })

  backend_user_data = templatefile("${path.module}/templates/backend-user-data.sh.tftpl", {
    core_api_image                 = var.core_api_image
    financial_api_image            = var.financial_api_image
    db_host                        = module.database.private_ip      
    rabbitmq_host                  = module.rabbitmq.private_ip    
    core_db_name                   = var.core_db_name
    core_db_user                   = var.core_db_user
    core_db_password               = var.core_db_password
    financial_db_name              = var.financial_db_name
    financial_db_user              = var.financial_db_user
    financial_db_password          = var.financial_db_password
    rabbitmq_user                  = var.rabbitmq_user
    rabbitmq_password              = var.rabbitmq_password
    rabbitmq_vhost                 = var.rabbitmq_vhost
    auth_service_client_id         = var.auth_service_client_id
    auth_service_client_secret     = var.auth_service_client_secret
    google_project_id              = var.google_project_id
    google_maps_api_key            = var.google_maps_api_key
    google_application_credentials = var.google_application_credentials
    google_service_account_json_base64 = var.google_service_account_json_base64
    ecr_registry                   = local.ec2_instance_profile_name != null ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com" : ""
    aws_region                     = data.aws_region.current.name
  })

  database_user_data = templatefile("${path.module}/templates/database-user-data.sh.tftpl", {
    core_db_name          = var.core_db_name
    core_db_user          = var.core_db_user
    core_db_password      = var.core_db_password
    financial_db_name     = var.financial_db_name
    financial_db_user     = var.financial_db_user
    financial_db_password = var.financial_db_password
  })

  nginx_user_data = templatefile("${path.module}/templates/nginx-user-data.sh.tftpl", {
    server_name          = var.server_name
    frontend_upstream_1  = "${module.frontend.private_ips[0]}:80"
    frontend_upstream_2  = "${module.frontend.private_ips[1]}:80"
    core_upstream_1      = "${module.backend.private_ips[0]}:8080"
    core_upstream_2      = "${module.backend.private_ips[1]}:8080"
    financial_upstream_1 = "${module.backend.private_ips[0]}:8081"
    financial_upstream_2 = "${module.backend.private_ips[1]}:8081"
  })
}
# ─── VPC ───────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  cidr = "10.0.0.0/16"
}

# ─── Network (Subnets, NAT, Routes) ───────────────────
module "network" {
  source = "./modules/network"

  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
}

# ─── Security Groups ──────────────────────────────────
module "security" {
  source = "./modules/security"

  vpc_id = module.vpc.vpc_id
}

# ─── NGINX (Reverse Proxy - Public) ──────────────────
module "nginx" {
  source = "./modules/nginx"

  ami                  = data.aws_ami.ubuntu.id
  subnet_id            = module.network.public_subnet_a
  security_group       = module.security.nginx_sg
  user_data            = local.nginx_user_data
  key_name             = aws_key_pair.ec2_ssh.key_name
  iam_instance_profile = local.ec2_instance_profile_name
}

# ─── Frontend (Private) ──────────────────────────────
module "frontend" {
  source = "./modules/frontend"

  ami                  = data.aws_ami.ubuntu.id
  private_subnets      = module.network.private_subnets_frontend
  security_group       = module.security.frontend_sg
  user_data            = local.frontend_user_data
  key_name             = aws_key_pair.ec2_ssh.key_name
  iam_instance_profile = local.ec2_instance_profile_name
}

# ─── Backend (Private) ───────────────────────────────
module "backend" {
  source = "./modules/backend"

  ami                  = data.aws_ami.ubuntu.id
  private_subnets      = module.network.private_subnets_backend
  security_group       = module.security.backend_sg
  user_data            = local.backend_user_data
  key_name             = aws_key_pair.ec2_ssh.key_name
  iam_instance_profile = local.ec2_instance_profile_name
}

# ─── RabbitMQ (Private, shared broker) ───────────────
module "rabbitmq" {
  source = "./modules/rabbitmq"

  ami            = data.aws_ami.ubuntu.id
  private_subnet  = module.network.private_subnet_backend
  security_group  = module.security.rabbitmq_sg
}

# ─── Database (Private) ──────────────────────────────
module "database" {
  source = "./modules/database"

  ami            = data.aws_ami.ubuntu.id
  private_subnet = module.network.private_subnet_database_a
  security_group = module.security.db_sg
  user_data      = local.database_user_data
  key_name       = aws_key_pair.ec2_ssh.key_name
}