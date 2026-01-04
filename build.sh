#!/usr/bin/env bash
# Render.com build script

echo "🚀 Instalando dependências..."
pip install --upgrade pip
pip install -r requirements-render.txt

echo "✅ Build concluído!"
