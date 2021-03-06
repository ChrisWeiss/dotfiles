ZSH=$HOME/.oh-my-zsh

export ANTIGEN_LOG=~/antigen_error.log
[ -f $HOME/.antigen.zsh ] && source ~/.antigen.zsh
[ -f /usr/local/share/antigen/antigen.zsh ] && source /usr/local/share/antigen/antigen.zsh
[ -f /opt/homebrew/share/antigen/antigen.zsh ] && source /opt/homebrew/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle mafredri/zsh-async                                                         # Needed by sindresorhus/pure
antigen bundle sindresorhus/pure                                                          # Pretty, minimal and fast ZSH prompt
antigen bundle docker
antigen bundle git
antigen bundle per-directory-history
antigen bundle vagrant
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle vi-mode
antigen bundle autojump                                                                     # aliases: 'j <string>'' to change to matching dir in history
antigen bundle history                                                                      # aliases: 'h' for history, 'hsi' for grepping history
antigen bundle pip
antigen bundle python
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh
antigen bundle extract                                                                      # aliases: 'x' for extract automatically using appropriate decompressor tool
antigen bundle command-not-found                                                            # Suggest packages for 'command not found'
antigen bundle docker-compose
antigen bundle fzf                                                                          # Fuzzy File Finder - Much substring matching
antigen bundle tmux
antigen bundle djui/alias-tips                                                              # A Zsh plugin to help remembering those shell aliases and Git aliases you once defined.
antigen bundle zsh-users/zsh-completions

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

[ -x "$(command -v nvim)" ] && alias vim='nvim' && export VISUAL='nvim -f' && export EDITOR='mvim -f'

export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:$PATH

if [[ $OSTYPE == darwin* ]]; then

    [ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

    # Fix for OS-X built-in CURL not supporting SSL correctly. Use Brew's CURL if it exists.
    # https://github.com/Homebrew/homebrew-cask/issues/83481
    [ -f "/usr/local/opt/curl/bin/curl" ] && export PATH="/usr/local/opt/curl/bin:$PATH" && export HOMEBREW_FORCE_BREWED_CURL=1

    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

    # Fix for slow prompt due to slow xcode git parse_git_dirty implementation
    # from http://marc-abramowitz.com/archives/2012/04/10/fix-for-oh-my-zsh-git-svn-prompt-slowness/

    function git_prompt_info() {
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
      echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    }

    alias locate='mdfind -name'
;fi


if [[ $OSTYPE == linux-gnu ]]; then
    [[ -s /home/cweiss/.autojump/etc/profile.d/autojump.sh ]] && source /home/cweiss/.autojump/etc/profile.d/autojump.sh
    autoload -U compinit && compinit -u

;fi

# For dotfiles management
[ -f ~/.zshrc-local ] && source ~/.zshrc-local
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

[[ -f ~/.password && -x "$(command -v ansible)" ]] && export ANSIBLE_VAULT_PASSWORD_FILE=~/.password

# Ansible human-readable stdout/stderr results display
[ -x "$(command -v ansible)" ] && export ANSIBLE_STDOUT_CALLBACK=debug

# SDKMan
[ -f $HOME/.sdkman/bin/sdkman-init.sh ] && source $HOME/.sdkman/bin/sdkman-init.sh

# PrettyPing
[ -f /usr/local/bin/prettyping ] && alias ping='prettyping --nolegend'

# bat
[ -f /usr/local/bin/bat ] && alias cat='bat'

# FZF setup
if [[ -x "$(command -v fzf)" ]]; then
  [ -f ~/.fzf.zsh ] && export FZF_DEFAULT_OPTS='--height 10% --layout=reverse' && source ~/.fzf.zsh

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

# Add yarn to path if exists
[ -d /.yarn/bin ] && export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# for jenv
[ -f $HOME/.jenv ] && export PATH="$HOME/.jenv/bin:$PATH" && eval "$(jenv init -)"

# Function to run a container locally
[ -x "$(command -v docker)" ] && dl () { docker run -it --volume `pwd`:`pwd` --workdir `pwd` "$1" /bin/bash }
