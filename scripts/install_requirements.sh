#!/bin/bash
# =============================================================
# install_requirements.sh
# Instala dependências Python extras para módulos fiscais BR
# Executado durante o build do Docker
# =============================================================

set -e

echo "=============================================="
echo " Instalando requirements Python extras (BR)"
echo "=============================================="

pip3 install --no-cache-dir --upgrade pip

if [ -f /requirements-br.txt ]; then
    echo "[*] Instalando pacotes de /requirements-br.txt..."
    pip3 install --no-cache-dir -r /requirements-br.txt
    echo "[OK] requirements-br.txt instalado com sucesso."
else
    echo "[WARN] Arquivo /requirements-br.txt não encontrado. Pulando."
fi

echo "=============================================="
echo " Instalação concluída!"
echo "=============================================="
