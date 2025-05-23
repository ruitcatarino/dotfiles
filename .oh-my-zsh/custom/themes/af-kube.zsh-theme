# af-minimal-kube.zsh-theme
#
# Adaptation of af-magic.zsh-theme by Rui Catarino
# Enhanced version with magical dashes and improved kubectl context display
# Displays only the last part of the current path with Kubernetes context

# Function to calculate dashes accounting for various prompt elements
function afmagic_dashes {
  # Check either virtualenv or condaenv variables
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"
  # If there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = \(${python_env}\) ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  else
    echo $COLUMNS
  fi
}

# Function to get the current Kubernetes context
function kubectl_context() {
  if command -v kubectl &>/dev/null; then
    local context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$context" ]]; then
      echo "$context"
    fi
  fi
}

# Function to display kubectl context with brackets only if context exists
function kubectl_prompt_info() {
  local context=$(kubectl_context)
  if [[ -n "$context" ]]; then
    echo " %{$fg[cyan]%}<${context}>%{$reset_color%}"
  fi
}

# Primary prompt: dashed separator, directory and git info
PROMPT="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}%c\$(git_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "

PROMPT2="%{$fg[red]%}\ %{$reset_color%}"

# Right prompt: return code, virtualenv, context (user@host), and kubectl context
RPROMPT='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'

# Add virtualenv info if function exists
if (( $+functions[virtualenv_prompt_info] )); then
  RPROMPT+='$(virtualenv_prompt_info)'
fi

RPROMPT+=" ${FG[237]}%n@%m%{$reset_color%}"
RPROMPT+='$(kubectl_prompt_info)'

# Git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# Virtualenv settings (if using oh-my-zsh virtualenv plugin)
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
