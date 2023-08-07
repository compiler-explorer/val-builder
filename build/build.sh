#!/bin/bash

set -ex

VERSION=$1
# TODO fetch the version here. if "trunk" then reset VERSION to be something like trunk-$(date)
# and ensure REVISION below accurately reflects the remote git version
# helper scripts for all this can be copy/pasted from the misc-builder repo

FULLNAME=val-${VERSION}
OUTPUT=$2/${FULLNAME}.tar.xz

REVISION="val-${VERSION}"  # todo if trunk, use a git SHA as the revision here
LAST_REVISION="${3}"

echo "ce-build-revision:${REVISION}"
echo "ce-build-output:${OUTPUT}"

if [[ "${REVISION}" == "${LAST_REVISION}" ]]; then
   echo "ce-build-status:SKIPPED"
   exit
fi

STAGING_DIR=$(pwd)/staging
BUILD_DIR=$(pwd)/build
rm -rf ${STAGING_DIR} ${BUILD_DIR}

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

# TODO build steps here, assuming STAGING_DIR is where `make install` or similar dumps to

popd

export XZ_DEFAULTS="-T 0"
tar Jcf "${OUTPUT}" --transform "s,^./,./val-${VERSION}/," -C "${STAGING_DIR}" .

echo "ce-build-status:OK"
