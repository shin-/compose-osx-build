#!/bin/bash

curl -f -u$BINTRAY_USERNAME:$BINTRAY_API_KEY -X GET \
  https://api.bintray.com/repos/docker-compose/${COMPOSE_BRANCH:-master}

if test $? -ne 0; then
  echo "Bintray repository ${COMPOSE_BRANCH:-master} does not exist ; abandoning upload attempt"
  exit 0
fi

curl -u$BINTRAY_USERNAME:$BINTRAY_API_KEY -X POST \
  -d "{\
    \"name\": \"${PKG_NAME}\", \"desc\": \"auto\", \"licenses\": [\"Apache-2.0\"], \
    \"vcs_url\": \"https://github.com/docker/compose\" \
  }" -H "Content-Type: application/json" \
  https://api.bintray.com/packages/docker-compose/${COMPOSE_BRANCH:-master}

curl -u$BINTRAY_USERNAME:$BINTRAY_API_KEY -X POST -d "{\
    \"name\": \"$COMPOSE_BRANCH\", \
    \"desc\": \"Automated build of the ${COMPOSE_BRANCH:-master} branch.\", \
  }" -H "Content-Type: application/json" \
  https://api.bintray.com/packages/docker-compose/${COMPOSE_BRANCH:-master}/${PKG_NAME}/versions

curl -f -T dist/docker-compose-${OS_NAME}-x86_64 -u$BINTRAY_USERNAME:$BINTRAY_API_KEY \
  -H "X-Bintray-Package: ${PKG_NAME}" -H "X-Bintray-Version: $COMPOSE_BRANCH" \
  -H "X-Bintray-Override: 1" -H "X-Bintray-Publish: 1" -X PUT \
  https://api.bintray.com/content/docker-compose/${COMPOSE_BRANCH:-master}/docker-compose-${OS_NAME}-x86_64 || exit 1
