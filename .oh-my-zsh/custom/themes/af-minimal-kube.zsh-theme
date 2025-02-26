# af-minimal-kube.zsh-theme
#
# Adaptation of af-magic.zsh-theme by Rui Catarino
# Displays only the last part of the current path with Kubernetes context

# Function to get the current Kubernetes context
function kubectl_context() {
  if command -v kubectl &>/dev/null; then
    kubectl config current-context 2>/dev/null
  fi
}

# Primary prompt: displays last part of the directory and git info
PROMPT='${FG[032]}%c$(git_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} '
PROMPT2="%{$fg[red]%}\ %{$reset_color%}"

# Right prompt with dynamic Kubernetes context
RPROMPT='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
RPROMPT+=" ${FG[237]}%n@%m%{$reset_color%}"
RPROMPT+=' %{$fg[cyan]%}<$(kubectl_context)>%{$reset_color%}'

# Git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"
