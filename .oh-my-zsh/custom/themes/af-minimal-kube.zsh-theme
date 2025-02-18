# af-minimal-kube.zsh-theme
#
# Adaptation of af-magic.zsh-theme with Kubernetes context
# Modified to display only the last part of the current path
#
# Author: Andy Fleming (Original af-magic)
# Adapted by: Rui Catarino

# Function to calculate the dashed separator size
function afmagic_dashes {
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"

  if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
    echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} ))
  else
    echo $COLUMNS
  fi
}

# Function to get the current Kubernetes context
function kubectl_context() {
  if command -v kubectl &>/dev/null; then
    echo "$(kubectl config current-context 2>/dev/null)"
  fi
}

# Primary prompt: displays a dashed separator, last part of the directory, and VCS info
PS1="${FG[237]}\${(l.$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}%c\$(git_prompt_info)\$(hg_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "
PS2="%{$fg[red]%}\ %{$reset_color%}"

# Right prompt: return code, virtualenv, user@host, and Kubernetes context
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"
if command -v kubectl &>/dev/null; then
  RPS1+=" %{$fg[cyan]%}<$(kubectl_context)>%{$reset_color%}"
fi

# Git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# Mercurial settings
ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# Virtual environment settings
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
