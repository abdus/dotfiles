#!/bin/bash

# ::rsync --out-format="%n" Flags::
# -a: copy dirs
# -L: copy symlinks
# -: erbose

COMMAND=$1

function update_eerything () {
  # alacritty
  rsync --out-format="%n" -La ~/.config/alacritty/* ./alacritty/

  # sway
  rsync --out-format="%n" -La ~/.config/sway/* ./sway/

  # waybar
  rsync --out-format="%n" -La ~/.config/waybar/* ./waybar/

  # i3status
  rsync --out-format="%n" -La ~/.config/i3status/* ./i3status/

  # neofetch
  rsync --out-format="%n" -La ~/.config/neofetch/* ./neofetch/

  # im/neoim
  rsync --out-format="%n" -La --exclude=plug ~/.config/nvim/* ./vim/
  rsync --out-format="%n" -La ~/.vimrc ./vim/

  # zsh
  rsync --out-format="%n" -La ~/.zshrc ./zsh/
  rsync --out-format="%n" -La ~/.zprofile ./zsh/

  # fzf
  rsync --out-format="%n" -La ~/.fzf.zsh ./fzf/
  rsync --out-format="%n" -La ~/.fzf.bash ./fzf/

  # gitconfig
  rsync --out-format="%n" -La ~/.gitconfig ./git/

  # scripts
  rsync --out-format="%n" --exclude="bin" -La ~/scripts/* ./scripts/
}

if [[ $COMMAND == "clean" ]]; then
  echo "Cleaing Workspace"
  find . -type d -not -path "./.git/*" -not -name ".git" -exec rm -vrf {} +
elif [[ $COMMAND == "update" ]]; then
  update_eerything;

  if [[ ! -d ".git" ]]; then
    git init
    git remote add origin git@github.com:abdus/dotfiles.git
  fi

  git add .
  git commit -m "$2" || git commit -m ":zap: automated updates"
  git push origin master
fi
