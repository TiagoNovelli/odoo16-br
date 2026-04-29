# Odoo 16 BR

Deploy Docker do Odoo 16 com dependencias brasileiras, preparado para rodar na VPS usando o PostgreSQL e o Traefik ja existentes.

## Estrutura

```text
odoo16-br/
|-- Dockerfile
|-- docker-compose.yml
|-- requirements-br.txt
|-- .env.example
|-- addons/
|-- config/
|   `-- odoo.conf
`-- scripts/
    `-- install_requirements.sh
```

Na VPS, este repositorio deve ficar em:

```bash
/var/lib/docker/volumes/sohome/odoo16-br
```

Os dados persistentes tambem ficam dentro desse diretorio:

```text
/var/lib/docker/volumes/sohome/odoo16-br/addons
/var/lib/docker/volumes/sohome/odoo16-br/config
/var/lib/docker/volumes/sohome/odoo16-br/logs
/var/lib/docker/volumes/sohome/odoo16-br/odoo-data
```

## Banco e rede

Este projeto nao sobe PostgreSQL. Ele usa o container PostgreSQL existente:

```text
container: odoo18-db
rede:      odoo-net
usuario:  odoo
```

As credenciais ficam no arquivo `.env`, que nao deve ser versionado.

Exemplo:

```bash
cp .env.example .env
nano .env
chmod 600 .env
```

## Deploy na VPS

```bash
cd /var/lib/docker/volumes/sohome
git clone https://github.com/TiagoNovelli/odoo16-br.git odoo16-br
cd odoo16-br

cp .env.example .env
nano .env
chmod 600 .env

mkdir -p addons config logs odoo-data
chown -R 101:101 logs odoo-data

docker compose up -d --build
```

Para atualizar:

```bash
cd /var/lib/docker/volumes/sohome/odoo16-br
git pull --ff-only
docker compose up -d --build --force-recreate
```

## Addons brasileiros

Clone os addons Odoo dentro de `addons/`.

```bash
cd /var/lib/docker/volumes/sohome/odoo16-br

git clone --depth=1 --branch 16.0 \
  https://github.com/OCA/l10n-brazil.git addons/l10n-brazil

git clone --depth=1 --branch 16.0 \
  https://github.com/OCA/edi.git addons/edi
```

As bibliotecas Python da organizacao `erpbrasil` sao instaladas no build da imagem via `requirements-br.txt`. Elas nao substituem os addons Odoo.

## Banco do Odoo 16

O arquivo `config/odoo.conf` usa:

```ini
dbfilter = ^odoo16.*$
```

Crie bancos para este Odoo com prefixo `odoo16`, por exemplo:

```text
odoo16_br
```

Isso evita que o Odoo 16 tente abrir bancos de outras instalacoes, como Odoo 18.

## Logs

```bash
docker logs -f odoo16_app
tail -f /var/lib/docker/volumes/sohome/odoo16-br/logs/odoo.log
```

## Acesso

O container fica exposto apenas para a rede Docker e o Traefik existente roteia:

```text
https://crm.brainess.com.br
```

Se houver outro Odoo usando o mesmo host no Traefik, ajuste as labels `traefik.http.routers.*.rule` no `docker-compose.yml`.
