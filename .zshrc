ZSH=$HOME/.oh-my-zsh

ZSH_THEME="smt"

plugins=(k docker git sublime osx per-directory-history jira vagrant zsh-autosuggestions vi-mode autojump history pip python fast-syntax-highlighting )

source $ZSH/oh-my-zsh.sh

#disable autocorrect
unsetopt correct_all

# Enable history search.
bindkey "^R" history-incremental-pattern-search-backward
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt inc_append_history extendedglob share_history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h"

export PATH=/usr/local/sbin:/usr/local/bin:$PATH

if [[ $OSTYPE == darwin* ]]; then

    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

    # Fix for slow prompt due to slow xcode git parse_git_dirty implementation
    # from http://marc-abramowitz.com/archives/2012/04/10/fix-for-oh-my-zsh-git-svn-prompt-slowness/

    function git_prompt_info() {
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
      echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    }

    alias locate='mdfind -name'

    # Set MacVim to not fork when invoked as default.
    export VISUAL='mvim -f'
    export EDITOR='mvim -f'


;fi

[ -f ~/.zshrc-local ] && source ~/.zshrc-local
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

[ -f ~/.password ] && export ANSIBLE_VAULT_PASSWORD_FILE=/Users/cweiss/.password

# human-readable stdout/stderr results display
export ANSIBLE_STDOUT_CALLBACK=debug

[ -f $HOME/.sdkman/bin/sdkman-init.sh ] && source $HOME/.sdkman/bin/sdkman-init.sh

[ -f ~/.fzf.zsh ] && export FZF_DEFAULT_OPTS='--height 10% --layout=reverse' && source ~/.fzf.zsh
[ -f /usr/local/bin/prettyping ] && alias ping='prettyping --nolegend'
[ -f /usr/local/bin/bat ] && alias cat='bat'

# f [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
f() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

