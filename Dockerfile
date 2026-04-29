FROM odoo:16.0

USER root

# Dependências do sistema para módulos fiscais brasileiros
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    libpq-dev \
    python3-dev \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia o script de instalação dos requirements Python extras
COPY scripts/install_requirements.sh /install_requirements.sh
RUN chmod +x /install_requirements.sh

# Copia o arquivo de requirements extras (fiscal BR)
COPY requirements-br.txt /requirements-br.txt

# Executa o script de instalação
RUN /install_requirements.sh

USER odoo

EXPOSE 8069 8072
