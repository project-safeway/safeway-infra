# Backend Stack (Core + Financial + RabbitMQ)

Este compose foi feito para a instância de backend e sobe os tres servicos no mesmo host:
- core-api (porta 8080)
- financial-api (porta 8081)
- rabbitmq (interno no compose)

## Como usar

1. Copie `.env.example` para `.env` e ajuste os valores.
2. Garanta que as imagens do Core e Financial estao publicadas no registry.
3. Suba a stack:

```bash
docker compose --env-file .env up -d
```

4. Verifique:

```bash
docker compose ps
docker compose logs -f core-api
docker compose logs -f financial-api
```

## Observacoes

- RabbitMQ nao expoe portas para fora do host por padrao.
- O acesso HTTP esperado a partir do NGINX e:
  - `http://<backend-private-ip>:8080`
  - `http://<backend-private-ip>:8081`
