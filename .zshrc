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

SSH_ICARUS_PATH=/home/rtc/projects/ssh-icarus
if [ -f $SSH_ICARUS_PATH/.bashrc ]; then
    . $SSH_ICARUS_PATH/.bashrc
fi

eval "$(register-python-argcomplete _ssh-icarus-cloud)"
eval "$(register-python-argcomplete iter_envs)"
eval "$(register-python-argcomplete goku)"
eval "$(zoxide init --cmd cd zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rtc/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rtc/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rtc/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rtc/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias edp="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output DP-2 --mode 1920x1080 --rotate normal --above eDP-1"
alias ehdmi="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --rotate normal --above eDP-1"
alias eoff="xrandr --output DP-2 --off && xrandr --output HDMI-1 --off"
alias vlrgg="python3 ~/docs/vlrgg/vlrgg.py"
alias wtwitch="~/docs/wtwitch/src/wtwitch"
alias pycharm="/opt/pycharm-2024.1/bin/pycharm.sh &"
alias dcup="docker compose up --remove-orphans --force-recreate -d"
alias dcupl="docker compose up --remove-orphans --force-recreate -d && docker compose logs -f"
alias dcupild="docker compose up --remove-orphans --force-recreate --build -d"
alias dcuppy="/home/rtc/docs/docker-compose-upppy.sh"
alias cl='find /home/rtc/projects/icarus -type f \( -name "*.mlog" -o -name "*.nv" \) -exec rm -f {} +'
alias ppoetry="docker run --rm -it --entrypoint poetry -e SHELL=/bin/bash -v .:/opt/project -w /opt/project artifactory.pt.fabamaq.com/wg-docker/devops/poetry-builder"
alias cleanmath="sudo rm /home/rtc/projects/icarus/*.nv && sudo rm /home/rtc/projects/icarus/*.mlog"

kea() {
    if [ "$1" = "-h" ]; then
        printf "kea: Execute the Django shell in a specific pod of an app.\n"
        printf "Usage: kea -n <namespace> <app_name>\n"
        printf "Example: kea -n my-namespace my-app\n"
        return 0
    fi
    
    if [ "$#" -ne 3 ]; then
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
    
    kubectl -n "$namespace" exec -it \
    $(kubectl -n "$namespace" get pod -l app="$app_name" -o jsonpath="{.items[0].metadata.name}") \
    -- python manage.py shell
}

kps() {
    if [ "$1" = "-h" ]; then
        printf "kps: List all pods in a specific namespace.\n"
        printf "Usage: kps -n <namespace>\n"
        printf "Example: kps -n my-namespace\n"
        return 0
    fi
    
    if [ "$#" -ne 2 ]; then
        kps -h
        return 1
    fi
    
    if [ "$1" != "-n" ]; then
        printf "First argument must be -n\n"
        kps -h
        return 1
    fi
    
    namespace="$2"
    
    printf "Listing pods in namespace: $namespace\n"
    kubectl -n "$namespace" get pods -o custom-columns="NAME:.metadata.name,APP:.metadata.labels.app,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp"
}

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
