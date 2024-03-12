{ config, pkgs, nixvim, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "breadman";
  home.homeDirectory = "/home/breadman";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # This is needed on non-NixOS systems
  # Else we get locale warnings each time you start a new shell
  # https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  nixpkgs.config.allowUnfreePredicate = _: true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    font-awesome
    #kitty
    #wofi
    #copyq

    ripgrep

    #firefox
    #slack
    #mongodb-compass
    #dolphin

    vimPlugins.neovim-ayu

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
      };
  };

  programs.nixvim = {
    enable = true;

    colorschemes.ayu.enable = true;
    extraPlugins = [ pkgs.vimPlugins.neovim-ayu ];

    globals.mapleader = " ";

    options = {
      number = true;
      relativenumber = true;

      shiftwidth = 4;

      scrolloff = 8;
    };

    plugins = {
      fugitive.enable = true;
      lualine.enable = true;
      undotree.enable = true;
      todo-comments.enable = true;
      friendly-snippets.enable = true;
      #fidget.enable = true;

      treesitter = {
	enable = true;
      };

      lsp = {
	enable = true;
	servers = {
	    bashls.enable = true;
	    cssls.enable = true;
	    dockerls.enable = true;
	    eslint.enable = true;
	    gopls.enable = true;
	    graphql.enable = true;
	    html.enable = true;
	    jsonls.enable = true;
	    lua-ls.enable = true;
	    nixd.enable = true;
	    pyright.enable = true;

	    rust-analyzer = {
		enable = true;
		installCargo = true;
		installRustc = true;
	    };

	    svelte.enable = true;
	    tailwindcss.enable = true;
	    terraformls.enable = true;
	    tsserver.enable = true;
	    typos-lsp.enable = true;
	    vuels.enable = true;
	    yamlls.enable = true;

	};

	keymaps  = {
	    diagnostic = {
		"<leader>q" = "open_float";
		"<leader>e" = "setloclist";
		"[d" = "goto_prev";
		"]d" = "goto_next";
	    };

	    lspBuf = {
		"gD" = "declaration";
		"gd" = "definition";
		"gi" = "implementation";
		"gr" = "references";
		"K" = "hover";
		"<C-k>" = "signature_help";
		"<leader>r" = "rename";
		"<leader>f" = "format";
	    };
	};
      };

      telescope = {
	enable = true;

	keymaps = {
	    "<leader>pf" = "find_files";
	    "<C-p>" = "git_files";
	    "<leader>ps" = "live_grep";
	};
      };
    };


    keymaps = [
      {
	action = "<cmd>Git<CR>";
	key = "<leader>gs";
      }
      {
	action = "<cmd>Git push<CR>";
	key = "<leader>gp";
      }
      {
	action = "<cmd>UndotreeToggle<CR>";
	key = "<leader>u";
      }
      {
	action = "<cmd>Ex<CR>";
	key = "<leader>pv";
      }
    ];
  };

  programs.waybar = {
    enable = false;
  };

  services.dunst.enable = false;

  wayland.windowManager.hyprland = {
    enable = false;
    settings = {
      source = "~/.config/hypr/base.conf";
      #exec-once = "waybar & hyprpaper & firefox";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/base.conf".source = configs/hyprland.conf;
    ".config/waybar/config".source = configs/waybar.jsonc;
    ".config/waybar/styles.css".source = configs/waybar-styles.css;
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

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      tf = "terraform";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
