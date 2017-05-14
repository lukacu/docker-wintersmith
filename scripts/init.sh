#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Do not run as root"
  exit
fi

if [ -z "${GITHUB_USERNAME}" ] && [ -z "${GITHUB_REPOSITORY}" ]; then
        echo "GITHUB_USERNAME or GITHUB_REPOSITORY not set. Exiting."
        exit 0;
fi

GIT_URL=https://github.com/${GITHUB_USERNAME}/${GITHUB_REPOSITORY}

if [ -z "${GITHUB_BRANCH}" ]; then
        GITHUB_BRANCH=master
fi

LOCAL_PATH=/srv/www

if [ ! -d "${LOCAL_PATH}/.git" ]; then
        git clone --branch="${GITHUB_BRANCH}" "$GIT_URL" "${LOCAL_PATH}"
        cd ${LOCAL_PATH} && wintersmith build
        exit 0;
fi

pushd ${LOCAL_PATH} > /dev/null
git fetch origin
LOCAL_REVISION=$(git rev-parse @)
REMOTE_REVISION=$(git rev-parse "origin/${GITHUB_BRANCH}")

echo "Local revision: $LOCAL_REVISION"
echo "Renite revision: $REMOTE_REVISION"
if [ ! $LOCAL_REVISION = $REMOTE_REVISION ]; then
        git merge "origin/${GITHUB_BRANCH}"
        wintersmith build
fi

popd > /dev/null

