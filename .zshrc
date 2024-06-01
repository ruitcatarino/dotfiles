export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="arrow"

plugins=(
git
sudo
zsh-autosuggestions
fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias edp="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output DP-2 --mode 1920x1080 --rotate normal --above eDP-1"
alias ehdmi="xrandr --output eDP-1 --mode 1920x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --rotate normal --above eDP-1"
alias eoff="xrandr --output DP-2 --off && xrandr --output HDMI-1 --off"
alias vlrgg="python3 ~/docs/vlrgg/vlrgg.py"
alias wtwitch="~/docs/wtwitch/src/wtwitch"

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

alias dcu="docker compose up -d --force-recreate --remove-orphans"
alias dce="docker compose exec"
alias dcl="docker compose logs -f"
alias pycharm="/opt/pycharm-2024.1/bin/pycharm.sh &"
