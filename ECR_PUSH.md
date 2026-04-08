# ECR Push and Deploy Guide

Este guia cobre o fluxo completo para:
- Subir a infra do zero.
- Publicar imagens no ECR.
- Atualizar servicos em ambiente ja existente (rollout).
- Fazer destroy para economizar creditos sem perder imagens do ECR.

## 0) Notas AWS Academy

- Em laboratorio Academy, normalmente nao e permitido criar IAM Role.
- Use profile existente no lab (exemplo: LabInstanceProfile).

Exemplo no terraform.tfvars:

```hcl
create_ec2_ecr_iam_resources      = false
existing_ec2_instance_profile_name = "LabInstanceProfile"
ecr_force_delete                  = false
ssh_key_pair_name                 = "safeway-ec2-key"
ssh_private_key_filename          = "safeway-ec2-key.pem"
```

Sobre a chave SSH:
- O Terraform gera a chave automaticamente.
- A chave privada fica no seu computador, dentro da pasta `safeway-infra`.
- O caminho exato aparece no output `ssh_private_key_path`.

## 1) Primeira subida (do zero)

### 1.1 Preparar variaveis

```bash
cd safeway-infra
cp terraform.tfvars.example terraform.tfvars
```

Editar terraform.tfvars com:
- senhas reais (db, rabbitmq, auth service)
- existing_ec2_instance_profile_name = "LabInstanceProfile"
- imagens ECR (pode iniciar com latest)
- credencial Google em base64 para o backend (google_service_account_json_base64)

Exemplo para gerar base64 em uma linha:

```bash
base64 -w0 ../back-end/src/main/resources/<service-account>.json
```

Depois, em terraform.tfvars:

```hcl
google_application_credentials      = "/run/secrets/gcp-credentials.json"
google_service_account_json_base64 = "<base64_em_linha_unica>"
```

### 1.2 Criar apenas repositorios ECR

```bash
terraform init
terraform plan -target=module.ecr -out tfplan-ecr
terraform apply tfplan-ecr
```

### 1.3 Login no ECR

```bash
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

aws ecr get-login-password --region "$AWS_REGION" \
	| docker login --username AWS --password-stdin "$ECR_REGISTRY"
```

### 1.4 Build e push das 3 imagens

```bash
TAG=1.0.1
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
export VITE_GOOGLE_MAPS_API_KEY=

cd ../front-end
docker build \
	--build-arg VITE_API_BASE_URL=/api \
	--build-arg VITE_API_FINANCEIRO_URL=/api/financeiro \
	--build-arg VITE_GOOGLE_MAPS_API_KEY= \
	-t "$ECR_REGISTRY/safeway-frontend:$TAG" .
docker push "$ECR_REGISTRY/safeway-frontend:$TAG"

cd ../back-end
docker build -t "$ECR_REGISTRY/safeway-core:$TAG" .
docker push "$ECR_REGISTRY/safeway-core:$TAG"

cd ../safeway-financial-api
docker build -t "$ECR_REGISTRY/safeway-financial:$TAG" .
docker push "$ECR_REGISTRY/safeway-financial:$TAG"
```

Importante sobre o mapa no frontend:
- A variavel correta e `VITE_GOOGLE_MAPS_API_KEY` (nao use `VITE_GOOGLE_MAPS_API`).
- Como o frontend e buildado com Vite, essa chave entra na imagem no momento do `docker build`.
- Se a chave mudar, gere uma nova tag e refaca build/push.

### 1.5 Apontar terraform para as tags publicadas

No terraform.tfvars:

```hcl
frontend_image      = "<account>.dkr.ecr.us-east-1.amazonaws.com/safeway-frontend:1.0.0"
core_api_image      = "<account>.dkr.ecr.us-east-1.amazonaws.com/safeway-core:1.0.0"
financial_api_image = "<account>.dkr.ecr.us-east-1.amazonaws.com/safeway-financial:1.0.0"
```

### 1.6 Subir infraestrutura completa

```bash
cd ../safeway-infra
terraform plan -out tfplan-full
terraform apply tfplan-full
terraform output
```

Importante:
- Neste fluxo inicial, nao precisa rollout separado.
- As EC2 ja nascem e fazem pull das imagens no boot via user_data.

### 1.7 Acesso SSH

Obter dados:

```bash
terraform output -raw nginx_elastic_ip
terraform output -raw ssh_private_key_path
terraform output frontend_private_ips
terraform output backend_private_ips
```

SSH no NGINX (publico):

```bash
ssh -i ./safeway-ec2-key.pem ubuntu@<NGINX_EIP>
```

SSH em instancia privada usando salto pelo NGINX (ProxyJump):

```bash
ssh -i ./safeway-ec2-key.pem -J ubuntu@<NGINX_EIP> ubuntu@<PRIVATE_IP>
```

Regras aplicadas na infra:
- NGINX aceita SSH (22) de qualquer origem com autenticacao por chave.
- Frontend, backend e database aceitam SSH (22) apenas a partir do security group do NGINX.

## 2) Atualizacao de versao com infra ja existente (rollout)

Quando ja existe ambiente ativo:

1. Build e push de nova tag no ECR.
2. Atualizar terraform.tfvars para a nova tag (ex: v2).
3. Rodar:

```bash
terraform plan -out tfplan-rollout
terraform apply tfplan-rollout
```

Isso e o rollout: recriar/atualizar instancias para subirem com a nova imagem.

## 3) Destroy e imagens no ECR

Pergunta comum: as imagens somem depois do destroy?

- As imagens so somem se o repositorio ECR for deletado.
- Com ecr_force_delete = false, repositorio com imagem nao e apagado automaticamente.

### 3.1 Recomendado para economizar creditos e manter imagens

Destruir infra de runtime e manter ECR:

```bash
terraform destroy \
	-target=module.nginx \
	-target=module.frontend \
	-target=module.backend \
	-target=module.database \
	-target=module.security \
	-target=module.network \
	-target=module.vpc
```

Com isso, voce reduz custo e preserva repositorios/imagens no ECR.

### 3.2 Se quiser apagar tudo (inclusive ECR)

Opcoes:

1. Esvaziar repositorios e depois terraform destroy.
2. Ou definir ecr_force_delete = true, aplicar, e depois destroy.

Atencao: neste caso, as imagens serao removidas.

## 4) Subir novamente depois de um destroy parcial

Se voce manteve ECR:

1. Validar se as tags ainda existem no ECR.
2. Garantir terraform.tfvars apontando para essas tags.
3. Rodar:

```bash
terraform plan -out tfplan-up
terraform apply tfplan-up
```

Nao precisa novo build/push se a tag ja existir no ECR.

terraform apply \
  -replace='module.frontend.aws_instance.frontend[0]' \
  -replace='module.frontend.aws_instance.frontend[1]'