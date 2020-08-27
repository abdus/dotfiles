# Setup fzf
# ---------
if [[ ! "$PATH" == */home/crow/scripts/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/crow/scripts/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/crow/scripts/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/crow/scripts/shell/key-bindings.bash"
