#!/bin/bash
set -ex

PATH="/usr/local/bin:$PATH"

cd compose
rm -rf venv

virtualenv -p $(which python) venv
venv/bin/pip install -r requirements.txt
venv/bin/pip install -r requirements-build.txt
venv/bin/pip install --no-deps .
./script/build/write-git-sha
venv/bin/pyinstaller docker-compose.spec
mv dist/docker-compose dist/docker-compose-Darwin-x86_64
dist/docker-compose-Darwin-x86_64 version
