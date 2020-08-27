# Setup fzf
# ---------
if [[ ! "$PATH" == */home/crow/scripts/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/crow/scripts/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/share/fzf/key-bindings.zsh"
