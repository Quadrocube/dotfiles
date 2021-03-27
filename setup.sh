#!/bin/bash

set -eux pipefail

brew install macvim
brew install autojump
brew install jq
brew install pngpaste
brew cask install kitty

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo source ${DIR}/vlad_profile >> ~/.profile
echo source ${DIR}/vlad_vimrc >> ~/.vimrc
ln -s ${DIR}/vlad_chunkwmrc ~/.chunkwmrc
ln -s ${DIR}/vlad_skhdrc ~/.skhdrc
ln -s ${DIR}/vlad_skhdrc_3 ~/.skhdrc_3
ln -s ${DIR}/vlad_skhdrc_1 ~/.skhdrc_1
rm ~/.config/kitty/kitty.conf
ln -s ${DIR}/vlad_kitty.conf ~/.config/kitty/kitty.conf
ln -s ${DIR}/macos-launch-services-cmdline ~/.config/kitty/macos-launch-services-cmdline

# configure gpg-agent to not ask for password for 4 days
mkdir -p ~/.gnupg
echo default-cache-ttl 345600 >> ~/.gnupg/gpg-agent.conf
echo max-cache-ttl 345600 >> ~/.gnupg/gpg-agent.conf

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git config --global push.default current

# add /usr/local/bin to the path of brew-installed commands (mainly for yabai)
sudo launchctl config user path "/usr/local/bin:$PATH"

# https://superuser.com/questions/433746/is-there-a-fix-for-the-too-many-open-files-in-system-error-on-os-x-10-7-1
# bump the limits on open files significantly:
echo 'kern.maxfiles=1572864' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'kern.maxfilesperproc=786432' | sudo tee -a /etc/sysctl.conf > /dev/null

ln -s /Users/vsterzhanov/dots/change-wallpaper-based-on-darkmode.plist /Users/vsterzhanov/Library/LaunchAgents/change-wallpaper-based-on-darkmode.plist
launchctl load ~/Library/LaunchAgents/change-wallpaper-based-on-darkmode.plist

echo "Now run :BundleInstall inside vim\n"
echo "And then run '~/.vim/bundle/YouCompleteMe/install.py --clang-completer'\n"
echo "And then add `auth sufficient pam_tid.so` to the top of /private/etc/pam.d/sudo for touch-id-based sudo auth"

# for emacs'es theme-magic
mkdir ~/libs && cd ~/libs
git clone https://github.com/dylanaraps/pywal && cd pywal
pip3 install --user .
