# NGINX Edge

Reverse proxy publico para frontend e APIs privadas.

## Estrutura

- `docker-compose.yml`: servico nginx com 80/443
- `templates/default.conf.template`: upstreams e rotas
- `certs/`: diretorio local com `fullchain.pem` e `privkey.pem`

## Uso

1. Copie `.env.example` para `.env` e atualize IPs privados das instancias.
2. Coloque os certificados TLS em `certs/fullchain.pem` e `certs/privkey.pem`.
3. Suba o nginx:

```bash
docker compose --env-file .env up -d
```
