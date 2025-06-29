{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ilya";
  home.homeDirectory = "/home/ilya";

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
    alacritty-graphics
    neovim
    nodejs_24
    aider-chat
    aichat

    # CLI
    fastfetch
    ncspot
    playerctl
    fzf
    oh-my-zsh
    xh
    nvimpager
    dust # better du
    duf # better df
    fd
    ripgrep
    jq
    yq
    cheat # your cheats for your commands
    tldr
    doggo # better dig
    tinty # Theme
    timg # Images

    # Nix
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

    # Misc
    nerd-fonts.hack

    # GUI
    telegram-desktop
    thunderbird-esr-bin
    spot
    ungoogled-chromium
    # signal-desktop wait for upgrading

    # Non-free GUI
    protonmail-bridge-gui
    # pkgs.zoom-us

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ilya/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    PAGER = "nvimpager";
  };

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
      olibrary_tab = ["tracks" "albums" "artists" "playlists" "browse"];
    };
  };

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];
}
