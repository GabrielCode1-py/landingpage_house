#!/bin/bash
set -e

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements-render.txt

echo "Build completed successfully!"
