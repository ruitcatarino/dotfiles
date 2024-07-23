export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export ZSH="$HOME/.oh-my-zsh"
export KUBE_EDITOR=nano

ZSH_THEME="mine"

plugins=(
    sudo
    zsh-autosuggestions
    fast-syntax-highlighting
    colored-man-pages
    docker-compose
    kubectl
)

source $ZSH/oh-my-zsh.sh

alias edp="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output DP-2 --mode 1920x1080 --rotate normal --above eDP-1"
alias ehdmi="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --rotate normal --above eDP-1"
alias eoff="xrandr --output DP-2 --off && xrandr --output HDMI-1 --off"
alias dcup="docker compose up --remove-orphans --force-recreate -d"

kea() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: kea -n <namespace> <app_name>"
        return 1
    fi
    
    if [ "$1" != "-n" ]; then
        echo "First argument must be -n"
        return 1
    fi
    
    namespace="$2"
    app_name="$3"
    
    kubectl -n "$namespace" exec -it \
    $(kubectl -n "$namespace" get pod -l app="$app_name" -o jsonpath="{.items[0].metadata.name}") \
    -- python manage.py shell
}

kla() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: kla -n <namespace>"
        return 1
    fi
    
    if [ "$1" != "-n" ]; then
        echo "First argument must be -n"
        return 1
    fi
    
    namespace="$2"
    
    echo "Listing apps (pods) in namespace: $namespace"
    kubectl -n "$namespace" get pods -o custom-columns="NAME:.metadata.name,APP:.metadata.labels.app,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp"
}
