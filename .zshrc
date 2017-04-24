ZSH=$HOME/.oh-my-zsh

ZSH_THEME="smt"

plugins=(docker git sublime osx jira vagrant vi-mode autojump zsh-syntax-highlighting virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

#disable autocorrect
unsetopt correct_all

# Enable history search.
bindkey "^R" history-incremental-pattern-search-backward
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups
setopt inc_append_history extendedglob share_history

alias tma='tmux attach -d -t'

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}



export PATH=/usr/local/bin:$PATH:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin/ansible/bin

if [[ $OSTYPE == darwin* ]]; then

    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

    # Fix for slow prompt due to slow xcode git parse_git_dirty implementation
    # from http://marc-abramowitz.com/archives/2012/04/10/fix-for-oh-my-zsh-git-svn-prompt-slowness/

    alias locate='mdfind -name'

    # Set MacVim to not fork when invoked as default.
    export VISUAL='mvim -f'
    export EDITOR='mvim -f'

;fi

[ -f ~/.zshrc-local ] && source ~/.zshrc-local
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
