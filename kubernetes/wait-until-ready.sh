#! /bin/bash -e
# This script works only with the pods containing `run` label.

# Pod label (must match spec.template.metadata.labels.run in deployment .yml file)
pod_label=$1
# The variable contains the time after which the timeout will be returned
timeout=$2

# Statefulset starts the pods individually, but with the convention `{statefulset-name}-{0-n}`
# The second member {0-n} corresponds to the amount of pods
# We have to manually defined name of the pods based of amount of replicas.
deployment_name="$(kubectl get deployment --selector "run=$pod_label" --output name)"
if [ -z "$deployment_name" ]; then
    pod_names=()
    replica_count="$(kubectl get statefulset $pod_label --output jsonpath='{.spec.replicas}')"
    for i in `seq 0 $(($replica_count-1))`; do
        pod_names+=(pods/$pod_label-$i)
    done
    [ -z "$pod_names" ] && echo "The pod does not exist!" && exit 1
else
    pod_name=$(kubectl get pod --selector "run=$1" --output name)

    [ -z "$pod_name" ] && echo "The pod does not exist!" && exit 1

    # Create an array containing lines from $pod_name.
    readarray -t pod_names <<< "$pod_name"
fi

for pod_name in "${pod_names[@]}"; do
    ./sleep-until-kubectl-status-is-ready.sh "$pod_name" "$timeout"
done
