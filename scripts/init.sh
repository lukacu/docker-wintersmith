#!/bin/bash

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
	git clone --depth=1 --branch="${GITHUB_BRANCH}" "$GIT_URL" "${LOCAL_PATH}"
	cd ${LOCAL_PATH} && wintersmith build
	exit 0;
fi

pushd ${LOCAL_PATH} > /dev/null
LOCAL_REVISION=$(git rev-parse @)
REMOTE_REVISION=$(git rev-parse "origin/${GITHUB_BRANCH}")

if [ ! $LOCAL_REVISION = $REMOTE_REVISION ]; then
	git pull --depth=1 --branch="${GITHUB_BRANCH}"
	wintersmith build
fi

popd > /dev/null
