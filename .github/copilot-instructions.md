# Copilot Instructions - Safeway Infra

Objetivo
- Infraestrutura como codigo para AWS via Terraform, provisionando VPC, EC2, SGs, ECR, e stack do Safeway.

Arquitetura e stack
- Terraform com modulos por dominio (vpc, network, backend, database, nginx, rabbitmq).
- EC2 com Docker e user-data templated.
- NGINX como edge/roteamento.

Padroes de codigo
- Cada modulo contem main.tf, variables.tf, outputs.tf.
- Recursos com prefixo safeway-.
- Variaveis sensiveis marcadas como sensitive.
- Templates de user-data em templates/*.tftpl.

Confiabilidades e riscos comuns
- Imagens podem estar com placeholders; revisar URLs de registry.
- Banco sem replicacao; risco de indisponibilidade.
- Credenciais locais (chaves SSH) precisam de cuidado.

Comandos usuais
- terraform init
- terraform plan -out=tfplan
- terraform apply tfplan
- terraform output

Boas praticas de mudanca
- Preferir modulos e variaveis a valores hardcoded.
- Manter SGs por camada e regras minimas.
- Atualizar templates quando mudar portas ou imagens.

Sugestoes de prompts
- "Revise seguranca dos SGs e proponha ajustes."
- "Como adicionar alta disponibilidade para o database?"
- "Verifique consistencia entre variaveis e templates."
