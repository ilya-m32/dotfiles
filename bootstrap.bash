#!/bin/bash

mkdir -p ~/.config

# Ubuntu-specific
if grep -q ID=ubuntu /etc/os-release; then
    if whiptail --yesno "Ubuntu detected. Install Ubuntu-specific apps?" 20 80 ;then
        echo -e "\nUbuntu OS, installing some must-haves"

        # And firefox
        sudo add-apt-repository ppa:mozillateam/ppa
        echo 'Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/mozilla-firefox

        # Basic software
        sudo apt update
        sudo apt install zsh ripgrep pwgen ncal tmux lm-sensors tldr cmake curl easy-rsa fonts-hack-ttf \
            gcc git jq nodejs npm ranger suckless-tools tmuxinator whois wmctrl xclip xdotool yarnpkg

        # Clean-up snap firefox
        sudo snap remove firefox

        # GUI
        if whiptail --yesno "Install GUI stuff?" 10 60 ;then
            sudo apt install firefox thunderbird thunderbird-locale-en-us thunderbird-locale-ru chromium-browser
        fi

        ## Add neovim install later
        ## deb: https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.deb
    fi
fi
# CentOS dev KVM specific
if grep -q ID=centos /etc/os-release; then
    if whiptail --yesno "Cent OS detected. Install usual stuff?" 20 80 ;then
        sudo yum install fuse-libs.x86_64 fuse.x86_64 ripgrep.x86_64
    fi

    mkdir -p "$HOME/.local/bin"
    wget https://github.com/neovim/neovim/releases/download/v0.11.0/nvim.appimage --output-document="$HOME/.local/bin/nvim"
    chmod +x "$HOME/.local/bin/nvim"
fi

# Vim
echo -e "\nInstalling Vim Plug..."
if [[ ! -d "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]
then
sh -c "curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
else
    echo "Plug is already installed"
fi

# Shell
echo -e "\nInstalling base16 shell themes..."
if [[ ! -d "$HOME/.config/base16-shell" ]]
then
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
else
    echo "Base16 shell themes are already installed"
fi

echo -e "\nInstalling oh-my-zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]
then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed"
fi

echo -e "\nInstalling fonts..."
mkdir -p ~/.local/share/fonts
cp .local/share/fonts/* ~/.local/share/fonts

echo -e "\nSet up main symlinks..."
mkdir -p $HOME/.config/nvim/
ln -sf $PWD/.config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf $PWD/.zshrc $HOME/.zshrc

mkdir -p $HOME/.config/tmux
ln -sf $PWD/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
ln -sf $PWD/.config/tmux/ilya-m.tmuxtheme $HOME/.config/tmux/ilya-m.tmuxtheme

echo -e "And copy rest of it"
cp -r $PWD/.oh-my-zsh $HOME/

echo -e "\nAll done!"
