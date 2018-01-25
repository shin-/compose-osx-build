#!/bin/bash

set -ex

python_version() {
  python -V 2>&1
}

openssl_version() {
  python -c "import ssl; print ssl.OPENSSL_VERSION"
}

echo "*** Using $(python_version)"
echo "*** Using $(openssl_version)"

git clone https://github.com/docker/compose.git && cd compose && git checkout ${COMPOSE_BRANCH:-master}

if !(which virtualenv); then
  pip install virtualenv
fi
