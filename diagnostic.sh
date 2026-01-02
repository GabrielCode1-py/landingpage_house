#!/bin/bash
# Script de Diagnóstico - PythonAnywhere

echo "==================================="
echo "DIAGNÓSTICO HOUSE ALIMENTOS"
echo "==================================="

echo -e "\n1. Verificando estrutura de diretórios:"
cd ~/mysite
tree -L 3 2>/dev/null || find . -maxdepth 3 -type d

echo -e "\n2. Arquivos em static/css:"
ls -lh static/css/ 2>/dev/null || echo "❌ Pasta static/css não encontrada"

echo -e "\n3. Arquivos em static/js:"
ls -lh static/js/ 2>/dev/null || echo "❌ Pasta static/js não encontrada"

echo -e "\n4. Arquivos em static/images:"
ls -lh static/images/ 2>/dev/null || echo "❌ Pasta static/images não encontrada"

echo -e "\n5. Arquivos em templates:"
ls -lh templates/ 2>/dev/null || echo "❌ Pasta templates não encontrada"

echo -e "\n6. Verificando permissões:"
ls -la static/ 2>/dev/null || echo "❌ Pasta static não encontrada"

echo -e "\n7. Teste de importação Flask:"
python -c "from app import app; print('✅ App importa corretamente')" 2>&1

echo -e "\n8. Versão Python no venv:"
source venv/bin/activate && python --version

echo -e "\n9. Pacotes instalados (principais):"
source venv/bin/activate && pip list | grep -E "Flask|Pillow|WTF"

echo -e "\n==================================="
echo "DIAGNÓSTICO COMPLETO"
echo "==================================="
