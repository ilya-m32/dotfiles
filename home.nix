{ config, pkgs, lib, guiEnabled, user, ... }:

let
  sharedEnvVars = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    PAGER = "nvimpager";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";

  targets.genericLinux.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Main tools
    neovim
    nodejs_22

    # CLI
    btop # better htop
    cheat # your cheats for your commands
    delta # better diff
    doggo # better dig
    duf # better df
    dust # better du
    fastfetch
    fd
    fzf
    jq
    ncspot
    nvimpager
    oh-my-zsh
    playerctl
    ripgrep
    timg # Images
    tinty # Theme
    tldr
    xh
    yq
    zx

    # LLMs
    aider-chat
    aichat

    # Web
    typescript-language-server
    nodePackages.svgo

    # Nix
    nil
    nixfmt-rfc-style

    # Lua
    luajitPackages.lua-lsp

    # Python
    python313
    python313Packages.python-lsp-server

    # Rust
    rustc
    rustfmt
    rust-analyzer
    cargo

    # Misc
    nerd-fonts.hack
  ] ++ lib.optionals guiEnabled [
    # GUI
    alacritty-graphics
    telegram-desktop
    thunderbird-esr-bin
    ungoogled-chromium
    xournalpp
    signal-desktop
    protonmail-bridge-gui
    # zoom-us
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # "./.config/nvim" = {
    #   source = ./config/nvim;
    #   recursive = true;
    # };
    # ln -sf $PWD/.config/nvim/init.vim $HOME/.config/nvim/init.vim
    # ln -sf $PWD/.zshrc $HOME/.zshrc

    # mkdir -p $HOME/.config/tmux
    # ln -sf $PWD/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
    # ln -sf $PWD/.config/tmux/ilya-m.tmuxtheme $HOME/.config/tmux/ilya-m.tmuxtheme
  };

  home.sessionVariables = sharedEnvVars;
  systemd.user.sessionVariables = sharedEnvVars;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Neovim
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    extraConfig = lib.fileContents "${config.home.homeDirectory}/.config/nvim/init.vim";
  };

  programs.ncspot = {
    enable = true;
    settings = {
      shuffle = true;
      gapless = true;
      backend = "pulseaudio";
      use_nerdfont = true;
      notify = true;
      initial_screen = "cover";
      library_tabs = ["albums" "artists" "playlists" "browse"];
    };
  };

  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];
}
