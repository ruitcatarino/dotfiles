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

if [ -d "$HOME/miniconda3" ]; then
  source "$HOME/miniconda3/bin/activate"
fi

source ~/.kubectl_helper.sh
source ~/.docker_helper.sh

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi
