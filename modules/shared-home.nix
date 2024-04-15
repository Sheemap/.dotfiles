{ config, pkgs, nixvim, ... }:
let
    rofiThemes = pkgs.stdenvNoCC.mkDerivation {
	pname = "rofi-themes-collection";
	version = "f87e083";

	src = pkgs.fetchgit {
	  url = "https://github.com/newmanls/rofi-themes-collection.git";
	  sparseCheckout = ["themes"];
	  rev = "f87e08300cb1c984994efcaf7d8ae26f705226fd";
	  hash = "sha256-/NPfy1rZL2p+6Nl7ukBZwTD+4F+UcVoQLDV2dHLElnY=";
	};

	installPhase = ''
	    runHook preInstall

	    install -Dm644 -t $out/ themes/*.rasi

	    runHook postInstall
	'';
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

  ];
  

  nixpkgs = {
    config.packageOverrides = pkgs: rec {
      catppuccin = pkgs.catppuccin.overrideAttrs {
	variant = "mocha";
	accent = "rosewater";
      };
    };
  };


  nixpkgs.config.allowUnfreePredicate = _: true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
	automatic = true;
	frequency = "weekly";
	options = "--delete-older-than 30d";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    font-awesome
    spotify

    ripgrep

    firefox
    obsidian
    keepassxc
    unzip

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

  programs.rofi = {
    enable = true;
    theme = "${rofiThemes}/squared-everforest.rasi";
  };

  programs.bat = { 
    enable = true;
    themes = {

catppuccin-mocha = {
    src = "${pkgs.catppuccin}/bat/Catppuccin Mocha.tmTheme";
  };
catppuccin-frappe = {
    src = "${pkgs.catppuccin}/themes/bat/catppuccin-frappe";
  };
catppuccin-macchiatto = {
    src = "${pkgs.catppuccin}/bat/Catppuccin Macchiato.tmTheme";
  };
catppuccin-latte = {
    src = "${pkgs.catppuccin}/bat/latte";
  };

    };
    config.theme = "catppuccin-macchiatto";
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
      };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
  
  programs.kitty = {
      enable = true;
      theme = "Dark Pride";
      shellIntegration.enableFishIntegration = true;
      font.name = "DejaVu Sans";
      extraConfig = ''
        confirm_os_window_close 0
      '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll  = "ls -l";
      tf  = "terraform";
      cat = "bat";
    };
    shellInit = ''
      set -x PATH $HOME/.local/bin $PATH
    '';
  };

  services.flameshot.enable = true;



  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/breadcat/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
