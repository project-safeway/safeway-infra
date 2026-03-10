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

  ami            = data.aws_ami.ubuntu.id
  subnet_id      = module.network.public_subnet_a
  security_group = module.security.nginx_sg
}

# ─── Frontend (Private) ──────────────────────────────
module "frontend" {
  source = "./modules/frontend"

  ami            = data.aws_ami.ubuntu.id
  private_subnet = module.network.private_subnet_frontend
  security_group = module.security.frontend_sg
}

# ─── Backend (Private) ───────────────────────────────
module "backend" {
  source = "./modules/backend"

  ami            = data.aws_ami.ubuntu.id
  private_subnet = module.network.private_subnet_backend
  security_group = module.security.backend_sg
}

# ─── Database (Private) ──────────────────────────────
module "database" {
  source = "./modules/database"

  ami            = data.aws_ami.ubuntu.id
  private_subnet = module.network.private_subnet_database
  security_group = module.security.db_sg
}