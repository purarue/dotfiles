{ config, pkgs, ... }:


# actual (name of the budgeting tool) configuration
let
  actualDataDir = "${config.home.homeDirectory}/.local/share/budget-data";
  actualCfgDir  = "${config.home.homeDirectory}/.config/actual";

  actualCfgFile = pkgs.writeText "actual.json" (builtins.toJSON {
    dataDir = actualDataDir;
    hostname = "127.0.0.1";
    port = 5006;
    serverFiles = "${actualDataDir}/server-files";
    userFiles   = "${actualDataDir}/user-files";
  });
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hex";
  home.homeDirectory = "/home/hex";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

    pkgs.pistol
    # tools
    pkgs.git  # TODO: migrate config here
    pkgs.eza
    pkgs.fzf
    pkgs.yarn
    pkgs.gnumake
    pkgs.dust
    pkgs.gawk
    pkgs.gnused
    pkgs.gammastep
    pkgs.ripgrep
    pkgs.udiskie
    pkgs.restic
    pkgs.bat
    pkgs.zsh
    pkgs.bash
    pkgs.wayshot
    pkgs.dragon-drop
    pkgs.figlet
    pkgs.fd
    pkgs.rofi
    pkgs.autotiling
    pkgs.inotify-tools
    pkgs.trash-cli
    pkgs.todo-txt-cli
    pkgs.boxes
    pkgs.zip
    pkgs.yadm
    pkgs.xh
    pkgs.wget
    pkgs.yt-dlp
    pkgs.up
    pkgs.vim
    pkgs.viddy
    pkgs.util-linux
    pkgs.unzip
    pkgs.unar
    pkgs.tree
    pkgs.toilet
    pkgs.ts # task spooler
    pkgs.strace
    pkgs.socat
    pkgs.shellcheck
    pkgs.scrot
    pkgs.rsync
    pkgs.rlwrap
    pkgs.stork
    pkgs.dua
    pkgs.exiftool
    pkgs.patch
    pkgs.pastel
    pkgs.parallel
    pkgs.pandoc
    pkgs.pamixer
    pkgs.optipng
    pkgs.ntfy-sh
    pkgs.nsxiv
    pkgs.nmap
    pkgs.mongodb-tools
    pkgs.neovim
    pkgs.tree-sitter
    pkgs.pulsemixer
    pkgs.pup
    pkgs.qrencode
    pkgs.net-tools
    pkgs.moreutils
    pkgs.mediainfo
    pkgs.maim
    pkgs.lynx
    pkgs.gocryptfs
    pkgs.asdf-vm
    pkgs.shfmt
    pkgs.git-open
    pkgs.abook
    pkgs.croc
    pkgs.newsraft
    pkgs.lm_sensors
    pkgs.jq
    pkgs.imagemagick
    pkgs.hyperfine
    pkgs.htop-vim
    pkgs.highlight
    pkgs.gron
    pkgs.netcat-gnu
    pkgs.glow
    pkgs.gum
    pkgs.gh
    pkgs.git-extras
    pkgs.delta  # TODO; migrate config here
    pkgs.libjpeg # for jpegtran
    pkgs.yq

    # TODO: configure vim/neovim in home-manager

    # gui applications
    # NOTE: hmm -- should these be installed here? or through arch/pacman?
    # mpv in particular installed through nix seems to have some error playing video (works fine through pacman)
    pkgs.kdePackages.okular
    pkgs.sqlitebrowser
    pkgs.gimp
    pkgs.gpxsee
    pkgs.keepassxc

    # operating system stuff
    pkgs.wev
    pkgs.wireplumber
    pkgs.wl-clipboard
    pkgs.wlrctl
    pkgs.wl-kbptr

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

    # actual setup
    ".local/share/budget-data/server-files/.keep" = { text = ""; };
    ".local/share/budget-data/user-files/.keep"  = { text = ""; };
    ".config/actual/actual.json".source = actualCfgFile;

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
  #  /etc/profiles/per-user/hex/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
    '';
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
