function kpf () {
    local service=$1
    local ports=$2
    local context=$3
    local namespace=$4
    local pod=$(kubectl "--context=$context" "--namespace=$namespace" get pods | awk "/^${service}/"' {print $1; exit}')
    kubectl "--context=$context" "--namespace=$namespace" port-forward "$pod" "$ports"
}