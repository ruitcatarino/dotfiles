autoload -Uz colors add-zsh-hook vcs_info
colors
setopt PROMPT_SUBST

NCOLOR=$([[ $EUID -eq 0 ]] && echo red || echo yellow)

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats 'git:%b%c%u'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'

update_prompt() {
    KUBE_CONTEXT=$(kubectl config current-context 2>/dev/null)
    vcs_info

    if [[ -n "$KUBE_CONTEXT" ]]; then
        PROMPT="%F{cyan}<${KUBE_CONTEXT}>%f "
    else
        PROMPT=""
    fi

    PROMPT+=" %F{$NCOLOR}%3~%f "
}

add-zsh-hook precmd update_prompt

RPROMPT='%F{$NCOLOR}${vcs_info_msg_0_}%f'

export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=31:cd=31:su=31:sg=31:tw=31:ow=31"
