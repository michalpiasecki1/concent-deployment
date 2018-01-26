#! /bin/sh -e

response="$(
    wget                                                                            \
        -O-                                                                         \
        --quiet                                                                     \
        --post-data='{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":4}'   \
        --header="Content-Type:application/json"                                    \
        "localhost:8545"                                                            \
        | jq '.result'                                                              \
)"

if [[ "$response" == "false" ]]; then
    echo READY
    exit 0
fi

echo NOT READY
exit 1
