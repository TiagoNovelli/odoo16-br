# Odoo 16 — Localização Brasileira (Docker)

Setup completo do Odoo 16 com módulos fiscais brasileiros via Docker Compose.

---

## Estrutura

```
odoo16-br/
├── Dockerfile                  # Imagem customizada do Odoo 16
├── docker-compose.yml          # Orquestração dos serviços
├── requirements-br.txt         # Dependências Python fiscais BR
├── scripts/
│   └── install_requirements.sh # Script de install (rodado no build)
├── config/
│   └── odoo.conf               # Configuração do Odoo
└── addons/                     # Seus módulos / localização BR
```

---

## Módulos fiscais recomendados (OCA / L10n-Brazil)

Clone dentro de `addons/` antes de subir:

```bash
# Localização oficial OCA Brasil
git clone --depth=1 --branch 16.0 \
  https://github.com/OCA/l10n-brazil.git addons/l10n-brazil

# Módulos de NF-e / NFS-e (Engenere/Akretion)
git clone --depth=1 --branch 16.0 \
  https://github.com/OCA/edi.git addons/edi
```

---

## Como subir

```bash
# 1. Clone os módulos BR (ver acima)
# 2. Build e sobe tudo
docker compose up -d --build

# Acompanhar logs
docker compose logs -f odoo

# Parar
docker compose down
```

Acesse: **http://localhost:8069**

---

## Primeiro acesso

1. Crie um banco de dados na tela inicial
2. Instale **l10n_br_base** (localização base BR)
3. Depois instale os módulos fiscais que precisar (NF-e, Boleto, etc.)

---

## Variáveis de ambiente

| Variável    | Padrão | Descrição              |
|-------------|--------|------------------------|
| `HOST`      | db     | Host do PostgreSQL     |
| `PORT`      | 5432   | Porta do PostgreSQL    |
| `USER`      | odoo   | Usuário do banco       |
| `PASSWORD`  | odoo   | Senha do banco         |

> **Atenção:** troque `admin_passwd` em `config/odoo.conf` antes de ir para produção!

---

## Produção

- Ative o bloco `nginx` no `docker-compose.yml`
- Configure certificado SSL em `nginx/certs/`
- Ajuste `workers` no `odoo.conf` conforme número de CPUs
- Use secrets do Docker ou `.env` para senhas
