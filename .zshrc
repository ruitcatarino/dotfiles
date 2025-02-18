export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-minimal-kube"

plugins=(
git
poetry
zsh-autosuggestions
zsh-syntax-highlighting
kubectl
sudo
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"

alias cd="z"

source ~/miniconda3/bin/activate
source ~/.kubectl_helper.sh
source ~/.docker_helper.sh
