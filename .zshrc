export ANTIGEN_LOG=~/antigen.log
ZSH=$HOME/.oh-my-zsh
source ~/.antigen.zsh
antigen use oh-my-zsh

antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship
#POWERLEVEL10K_COLOR_SCHEME='light'
##antigen theme romkatv/powerlevel10k

antigen bundle supercrabtree/k
antigen bundle docker
antigen bundle git
antigen bundle per-directory-history
antigen bundle vagrant
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle vi-mode
antigen bundle autojump
antigen bundle history
antigen bundle pip
antigen bundle python
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh
antigen bundle extract
antigen bundle sudo # Esc twice to add sudo in front of any command
antigen bundle command-not-found # This plugin uses the command-not-found package for zsh to provide suggested packages to be installed if a command cannot be found.
antigen bundle docker-compose
antigen bundle fzf
antigen bundle sudo # Easily prefix your current or previous commands with sudo by pressing esc twice
antigen bundle tmux
antigen bundle djui/alias-tips # A Zsh plugin to help remembering those shell aliases and Git aliases you once defined.
antigen bundle gitignore # This plugin enables you the use of gitignore.io from the command line. You need an active internet connection.

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

antigen apply

#disable autocorrect
unsetopt correct_all

# Enable history search.
bindkey "^R" history-incremental-pattern-search-backward
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt inc_append_history extendedglob share_history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h"

# A little verbosity
alias cp='cp -iv'
alias mv='mv -iv'
alias rmdir='rmdir -v'
alias ln='ln -v'

alias vim='nvim'
export VISUAL='nvim -f'
export EDITOR='mvim -f'

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
;fi

# For dotfiles management
[ -f ~/.zshrc-local ] && source ~/.zshrc-local
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

[ -f ~/.password ] && export ANSIBLE_VAULT_PASSWORD_FILE=/Users/cweiss/.password

# Ansible human-readable stdout/stderr results display
export ANSIBLE_STDOUT_CALLBACK=debug

# SDKMan
[ -f $HOME/.sdkman/bin/sdkman-init.sh ] && source $HOME/.sdkman/bin/sdkman-init.sh

# PrettyPing
[ -f /usr/local/bin/prettyping ] && alias ping='prettyping --nolegend'

# bat
[ -f /usr/local/bin/bat ] && alias cat='bat'

if [[ -f ~/.fzf.zsh ]]; then
source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 10% --layout=reverse'

# f [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
f() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
;fi

# TMUX Setup
[[ -d ~/.tmux && ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
