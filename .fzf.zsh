# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/Cellar/fzf/0.18.0/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/Cellar/fzf/0.18.0/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/Cellar/fzf/0.18.0/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/Cellar/fzf/0.18.0/shell/key-bindings.zsh"
