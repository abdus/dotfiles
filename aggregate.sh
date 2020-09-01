#!/bin/bash

# ::rsync --out-format="%n" Flags::
# -a: copy dirs
# -L: copy symlinks
# -: erbose

COMMAND=$1

function update_eerything() {
  # alacritty
  rsync --out-format="%n" -La ~/.config/alacritty/* ./alacritty/

  # sway
  rsync --out-format="%n" -La ~/.config/sway/* ./sway/

  # waybar
  rsync --out-format="%n" -a ~/.config/waybar/* ./waybar/

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

  # rofi
  rsync --out-format="%n" -La ~/.config/rofi/* ./rofi/

  # rofi
  rsync --out-format="%n" -La ~/.config/mako/* ./mako/

}

if [[ $COMMAND == "clean" ]]; then
  echo "Cleaing Workspace"
  find . -type d -not -path "./.git/*" -not -name ".git" -exec rm -vrf {} +
elif [[ $COMMAND == "update" ]]; then
  update_eerything

  if [[ ! -d ".git" ]]; then
    git init
    git remote add origin git@github.com:abdus/dotfiles.git
  fi

  git add .
  git commit -m "$2" || git commit -m ":zap: automated updates"
  git push origin master
fi

# github badges: software - version number
BADGES=""

# $1 program name     $2 version number
function gen_badges() {
  BADGES="${BADGES}<img src='https://img.shields.io/badge/$1-$2-blueviolet' alt='$1' />\n"
}

gen_badges alacritty "v$(alacritty --version | grep -oe '[0-9].[0-9]*');" # alacritty
gen_badges fzf "v$(fzf --version | grep -oe '[0-9].*\S')"                 # fzf
gen_badges git "v$(git --version | grep -ow '[0-9].*[0-9]')"              # git
gen_badges neofetch "v$(neofetch --version | grep -oe '[0-9].*[0-9]')"    # neofetch
gen_badges vim "v8.2"                                                     # vim
gen_badges neovim $(nvim --version | grep -ow 'v[0-9]*.*[0-9]')           # nvim
gen_badges waybar $(waybar --version | grep -ow 'v[0-9]*.*[0-9]')         # waybar
gen_badges zsh "v$(zsh --version | grep -oe '[0-9]\.[0-9]')"              # zsh
gen_badges sway "$(sway --version | grep -oe 'v[0-9].*')"                 # sway

echo -e $BADGES | wl-copy
echo "Badges Copied!"
