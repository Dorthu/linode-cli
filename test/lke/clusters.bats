#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'
load '../common'

##################################################################
#  WARNING: THIS TEST WILL DELETE ALL OF YOUR LKE CLUSTERS       #
#  WARNING: USE A SEPARATE TEST ACCOUNT WHEN RUNNING THESE TESTS #
##################################################################

setup() {
    suiteName="lke-clusters"
    setToken "$suiteName"
}

teardown() {
    if [ "$LAST_TEST" = "TRUE" ]; then
        clearToken "$suiteName"
    fi
}

@test "it should deploy an lke cluster" {
    run linode-cli lke cluster-create \
        --region us-east \
        --label cli-test-1 \
        --node_pools.type g6-nanode-1 \
        --node_pools.count 1 \
        --node_pools.disks '[{"type":"ext4","size":1024}]' \
        --k8s_version 1.16 \
        --text \
        --delimiter "," \
        --no-headers \
        --format 'label,region,k8s_version' \
        --no-defaults

    assert_output --regexp "cli-test-1,us-east,1.16"
}


@test "it should remove all lke clusters" {
    LAST_TEST="TRUE"

    run removeLkeClusters
}
