export KUBE_EDITOR=nano

CACHE_KUBE_DURATION=300
CACHE_KUBE_DIR="/tmp/kubectl_helper_cache"

mkdir -p "$CACHE_KUBE_DIR"


fetch_cached_data() {
    local context=$(kubectl config current-context 2>/dev/null)
    if [[ -z "$context" ]]; then
        printf "Error: Unable to determine current Kubernetes context.\n" >&2
        return 1
    fi

    local cache_file="$CACHE_KUBE_DIR/${context}_$1"
    local command="$2"
    
    if [[ -f "$cache_file" && $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt $CACHE_KUBE_DURATION ]]; then
        cat "$cache_file"
    else
        eval "$command" > "$cache_file" 2>/dev/null
        cat "$cache_file"
    fi
}

### kea, Execute a command within a specific pod ###

kea() {
    if [ "$1" = "-h" ]; then
        printf "kea: Execute a command within a specific pod of an app.\n"
        printf "Usage: kea -n <namespace> <app_name> [command]\n"
        printf "Example: kea -n my-namespace my-app\n"
        printf "         kea -n my-namespace my-app 'python -m asyncio'\n"
        printf "\nIf no [command] is provided, 'python manage.py shell' will be executed by default.\n"
        return 0
    fi
    
    if [ "$#" -lt 3 ]; then
        kea -h
        return 1
    fi
    
    if [ "$1" != "-n" ]; then
        printf "First argument must be -n\n"
        kea -h
        return 1
    fi
    
    namespace="$2"
    app_name="$3"
    shift 3
    
    pod_name=$(kubectl -n "$namespace" get pod -l app="$app_name" \
        -o jsonpath="{.items[?(@.status.phase=='Running')].metadata.name}"| tr ' ' '\n' | head -n 1)
    
    if [ -z "$pod_name" ]; then
        printf "Error: No running pod found for app '%s' in namespace '%s'\n" "$app_name" "$namespace"
        return 1
    fi
    
    if [ "$#" -eq 0 ]; then
        kubectl -n "$namespace" exec -it "$pod_name" -- python manage.py shell
    else
        kubectl -n "$namespace" exec -it "$pod_name" -- "$@"
    fi
}

_kea_completion() {
    local cur prev opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="-n"

    case "$prev" in
        -n)
            COMPREPLY=( $(fetch_cached_data "namespaces" "kubectl get ns -o custom-columns=':metadata.name' | tr -d '\r' | grep '^$cur'") )
            ;;
        *)
            if [[ "${COMP_WORDS[1]}" == "-n" && "${COMP_WORDS[2]}" ]]; then
                local namespace="${COMP_WORDS[2]}"
                COMPREPLY=( $(fetch_cached_data "apps_$namespace" "kubectl -n $namespace get pod -o jsonpath='{.items[*].metadata.labels.app}' | tr ' ' '\n' | grep '^$cur'") )
            fi
            ;;
    esac
}

complete -F _kea_completion kea


### kps, List all pods in a specific namespace ###

kps() {
    if [ "$1" = "-h" ]; then
        printf "kps: List all pods in a specific namespace.\n"
        printf "Usage: kps -n <namespace>\n"
        printf "If no namespace is provided, it lists all namespaces.\n"
        printf "Example: kps -n my-namespace\n"
        return 0
    fi

    if [ "$#" -eq 0 ]; then
        printf "No namespace specified. Listing all namespaces:\n"
        kubectl get ns
        return 0
    fi

    if [ "$#" -ne 2 ] || [ "$1" != "-n" ]; then
        printf "Invalid usage.\n"
        kps -h
        return 1
    fi

    namespace="$2"

    printf "Listing pods in namespace: $namespace\n"
    kubectl -n "$namespace" get pods -o custom-columns="NAME:.metadata.name,APP:.metadata.labels.app,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp"
}

_kps_completion() {
    local cur prev opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="-n"

    if [ "$prev" == "-n" ]; then
        COMPREPLY=( $(fetch_cached_data "namespaces" "kubectl get ns -o custom-columns=':metadata.name' | tr -d '\r' | grep '^$cur'") )
    else
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
    fi
}

complete -F _kps_completion kps

### kla, Get the logs of all pods with a specific label ###

kla() {
    if [ "$1" = "-h" ]; then
        printf "kla: Tail the logs of all pods with a specific label in a namespace.\n"
        printf "Usage: kla -n <namespace> <app_label>\n"
        printf "Example: kla -n my-namespace my-app-label\n"
        return 0
    fi

    if [ "$#" -ne 3 ] || [ "$1" != "-n" ]; then
        kla -h
        return 1
    fi
    
    namespace="$2"
    app_label="$3"
    
    kubectl -n "$namespace" logs -f -l app="$app_label" --tail=250 --max-log-requests 10
}


_kla_completion() {
    local cur prev opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="-n -h"

    case "$prev" in
        -n)
            COMPREPLY=( $(fetch_cached_data "namespaces" "kubectl get ns -o custom-columns=':metadata.name' | tr -d '\r' | grep '^$cur'") )
            ;;
        *)
            if [[ "${COMP_WORDS[1]}" == "-n" && "${COMP_WORDS[2]}" ]]; then
                local namespace="${COMP_WORDS[2]}"
                COMPREPLY=( $(fetch_cached_data "apps_$namespace" "kubectl -n $namespace get pod -o jsonpath='{.items[*].metadata.labels.app}' | tr ' ' '\n' | grep '^$cur'") )
            else
                COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            fi
            ;;
    esac
}

complete -F _kla_completion kla

### keditconf, Edit the configmap of such app. ###

keditconf() {
    if [ "$1" = "-h" ]; then
        printf "keditconf: Edit the configmap of such app.\n"
        printf "Usage: keditconf -n <namespace> <app_label>\n"
        printf "Example: keditconf -n my-namespace my-app-label\n"
        return 0
    fi

    if [ "$#" -ne 3 ] || [ "$1" != "-n" ]; then
        keditconf -h
        return 1
    fi

    namespace="$2"
    app_label="$3"

    kubectl edit configmap "$app_label" -n "$namespace"
}

### kcd, Change current context ###

kcd() {
    kubectl config use-context "$1"
}

_kcd_completions() {
    local curr_arg
    curr_arg="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(kubectl config get-contexts -o name)" -- "$curr_arg") )
}

complete -F _kcd_completions kcd
