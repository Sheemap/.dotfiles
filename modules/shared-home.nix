{ pkgs, ... }:
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

  ];
  

  nixpkgs = {
    #config.packageOverrides = pkgs: rec {
    #  catppuccin = pkgs.catppuccin.overrideAttrs {
#	variant = "mocha";
#	accent = "rosewater";
#      };
#    };
  };


  nixpkgs.config.allowUnfreePredicate = _: true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
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
    font-awesome
    spotify
    ripgrep

    # Theres some weirdness with opengl on non nix distros
    # Just using their respective package manager to get firefox
    # firefox
    
    obsidian
    keepassxc
    unzip
    insomnia
    nix-output-monitor
    vial
    via
    warpd
    fzf
    dust
    htop
    autotiling
    nerdfonts

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
  };
  
  programs.kitty = {
      enable = true;
      #theme = "Dark Pride";
      theme = "Everforest Dark Hard";
      #theme = "Rose Pine";
      shellIntegration.enableFishIntegration = true;
      font.name = "DejaVu Sans";
      extraConfig = ''
        confirm_os_window_close 0
      '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      tf  = "terraform";
      cat = "bat";
      hs = "home-manager switch --flake ~/.dotfiles &| nom";
      ns = "sudo nixos-rebuild switch --flake ~/.dotfiles &| nom";
      nv = "nvim .";
    };
    shellInit = ''
      set -x PATH $HOME/.local/bin $PATH
      set -x NIXPKGS_ALLOW_UNFREE 1
      direnv hook fish | source
    '';
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
	sensible
	rose-pine
	vim-tmux-navigator
    ];
    extraConfig = ''
      # Smart pane switching with awareness of vim splits.

      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
	| grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

      # -n is shorthand for -Troot
      # mirror vim keybindings
      bind-key -n 'C-q' if-shell "$is_vim" 'send-keys C-q' 'kill-pane'
      bind-key -n 'C-v' if-shell "$is_vim" 'send-keys C-v' 'split-window -h'
      bind-key -n 'C-s' if-shell "$is_vim" 'send-keys C-s' 'split-window'

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      # Forwarding <C-\\> needs different syntax, depending on tmux version
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
	"bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
	"bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

    '';

  };

  programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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
