#!/usr/bin/bash
# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.
set -eu

bundle=$1
track=$2
risk=$3

channel="${track}/${risk}"

pushd ${bundle} > /dev/null
trap popd EXIT

if ! grep ${risk} .supported-charm-risks ; then
    echo "Invalid risk: ${risk}"
    exit 1
fi

echo "::group::Alter charm channels"
yq -e -i '.applications.k8s.channel = "'${channel}'"' bundle.yaml
yq -e -i '.applications.k8s-worker.channel = "'${channel}'"' bundle.yaml
yq '.applications | with_entries(select(.key | test("k8s*"))) | .[].channel' bundle.yaml
echo ""::endgroup::""

echo "::group::Pack Bundle"
charmcraft pack -v
echo ""::endgroup::""

