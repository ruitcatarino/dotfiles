export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/opt/nvim-linux64/bin"
export KUBE_EDITOR=nano


ZSH_THEME="mine"
#ZSH_THEME="arrow"

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
alias dcupild="docker compose up --remove-orphans --force-recreate --build -d"
alias dcuppy="/home/rtc/docs/docker-compose-upppy.sh"
alias cl='find /home/rtc/projects/icarus -type f \( -name "*.mlog" -o -name "*.nv" \) -exec rm -f {} +'

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
