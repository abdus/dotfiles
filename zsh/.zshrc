# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-bin/bin:$HOME/.gem/ruby/2.6.0/bin:$HOME/go/bin:$HOME/Desktop/scripts:$HOME/.gem/ruby/2.7.0/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.deno/bin:~/scripts:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="flazz"
plugins=()
source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR="nvim"

# Run neofetch on start-up
clear && echo '' && echo '' && neofetch

# Reload terminal
alias reload="source ~/.zshrc"

# Android Studio/React Native CLI Config
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

#====    ask to launch sway when in tty1    ====================================
TTY=$(tty)

if [[ "$TTY" == "/dev/tty1" ]]; then
  # change tty font
  setfont ter-powerline-v18b.psf.gz

  printf "Want to launch SwayWM? [yN] : ";
  read RESP;

  if [[ ("$RESP" == "y") || ("$RESP" == "Y") ]]; then
    echo "Launching Sway ... ";
    sway;
  else
    echo "Alright! Sway won't be launched."
  fi
fi

# fzf conf
export FZF_DEFAULT_OPTS="--layout=reverse --height=40%"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#====    ALIAS    ==============================================================
alias vim="/usr/bin/nvim"

alias cd="cd $1"
alias ..="cd ../"
alias ...="cd ../../"
alias 3.="cd ../../../"

alias feh="feh -S filename --borderless"

alias ga="git add"
alias gaa="git add ."
alias gc="git commit -m"
alias gca="git commit --ammend -m"
alias gpush="git push origin"
alias gpull="git pull origin"

alias zshconf="/usr/bin/nvim ~/.zshrc"
alias swayconf="/usr/bin/nvim ~/.config/sway/config"
alias nvimconf="/usr/bin/nvim ~/.config/nvim/init.vim"
alias roficonf="/usr/bin/nvim ~/.config/rofi/material.rasi"
alias waybarconf="/usr/bin/nvim ~/.config/waybar/config"

alias dotfiles="cd ~/Dev/dotfiles"

#====    FUNCTIONS    ==========================================================
function cd() {
  builtin cd "$@" && tree -L 2 --noreport;
}

function haste() {
  curl -XPOST 'https://hastebin.com/documents' --data-binary @-
}
