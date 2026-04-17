#!/bin/bash

set -o errexit
set -o pipefail

echo "Running unit-tests.sh"

# Ensure that some home var is set and that it's not the root
export HOME=${HOME:=/tmp/kubebuilder/testing}
if [ $HOME == "/" ]; then
  export HOME=/tmp/kubebuilder/testing
fi

# mockgen must support the generic prism-go-client interfaces used in this branch.
MOCKGEN_VERSION="v0.6.0"
echo "Installing mockgen@${MOCKGEN_VERSION}"
go install -mod=mod "go.uber.org/mock/mockgen@${MOCKGEN_VERSION}"

# setup-envtest is implicitly available in the nutanix-cloud-native/cluster-api-provider-nutanix CI environment.
SETUP_ENVTEST_VERSION="release-0.23"
echo "Installing setup-envtest@${SETUP_ENVTEST_VERSION}"
go install -mod=mod "sigs.k8s.io/controller-runtime/tools/setup-envtest@${SETUP_ENVTEST_VERSION}"

GOFLAGS='-mod=readonly' make unit-test
