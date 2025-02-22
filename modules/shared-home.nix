{ pkgs, localPkgs, ... }:
let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "b8134f01b0ac176f1cf2a7043a5abf5a1a29457b";
    hash = "sha256-gzf0/Ltw8mGMsEFBTUuN33MSFtUP4xhdxfoZFntaycQ=";
  };
in
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    ./nixvim.nix
    ./tmux.nix
    ./helix.nix
  ];

  nixpkgs = {
    #config.packageOverrides = pkgs: rec {
    #  catppuccin = pkgs.catppuccin.overrideAttrs {
    #  variant = "mocha";
    #  accent = "rosewater";
    #      };
    #    };
  };

  nixpkgs.config.allowUnfreePredicate = _: true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # There's some weirdness with opengl on non nix distros
    # Just using their respective package manager to get firefox
    # firefox

    # Nixpkgs version is out of date
    # Just going to use their installer
    # devbox

    autotiling
    dust
    eza
    font-awesome
    fzf
    htop
    hyfetch
    insomnia
    keepassxc
    libreoffice
    libsecret
    nix-output-monitor
    obsidian
    ripgrep
    spotify
    tauon
    thunderbird
    unzip
    via
    vial
    warpd

    localPkgs.ccase

    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file.".config/warpd/config".source = ../configs/warpd.conf;
  home.file.".config/fish/functions/fish_prompt.fish".source =
    ../configs/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source =
    ../configs/fish/functions/fish_right_prompt.fish;
  home.file.".config/fish/functions/fish_greeting.fish".source =
    ../configs/fish/functions/fish_greeting.fish;

  programs.bat = {
    enable = true;

    themes = {
      catppuccin-mocha = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Mocha.tmTheme";
      };
      catppuccin-macchiato = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
      catppuccin-frappe = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Frappe.tmTheme";
      };
      catppuccin-latte = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Latte.tmTheme";
      };
    };

    config.theme = "catppuccin-mocha";
  };
  programs.ripgrep.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.git = {
    enable = true;
    userEmail = "jamman98@gmail.com";
    userName = "Jamis Hartley";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz.override { useUasm = true; };
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "dark_pride";
    #themeFile = "everforest_dark_hard";
    #themeFile = "Rose Pine";
    #themeFile = "Dracula";
    #themeFile = "Nightfox";
    #themeFile = "Chalk";
    shellIntegration.enableFishIntegration = true;
    font.name = "Jetbrains Mono";
    extraConfig = ''
      confirm_os_window_close 0
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      tf = "terraform";
      cat = "bat";
      ls = "eza";
      hs = "home-manager switch --flake ~/.dotfiles";
      ns = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      nv = "nvim";
      db = "devbox";
      lg = "lazygit";
    };
    shellInit = ''
      set -x PATH $HOME/.local/bin $PATH
      set -x NIXPKGS_ALLOW_UNFREE 1
      set -x SHELL fish
      direnv hook fish | source
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
  };
  services.flameshot.enable = true;
  services.redshift = {
    enable = true;
    latitude = 40.7596;
    longitude = -111.8876;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
