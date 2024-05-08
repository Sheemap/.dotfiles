{ config, pkgs, localPkgs, nixvim, ... }:
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
    imports =
    [ # Include the results of the hardware scan.
      ../../modules/shared-home.nix
      ../../modules/i3.nix
      #../../modules/hyprland.nix
      #../../modules/xmonad.nix
    ];
    home.username = "breadcat";
    home.homeDirectory = "/home/breadcat";

    home.packages = with pkgs; [
	arandr
	discord
	lutris
	#wineWowPackages.stable
	wineWowPackages.full
	winetricks
	xivlauncher
	pkgsi686Linux.gperftools
	element-desktop
	obs-studio
	vlc

	localPkgs.pyfa
    ];

    
    programs.rofi = {
	enable = true;
	theme = "${rofiThemes}/squared-everforest.rasi";
    };
    programs.kitty.font.size = 18;
    programs.nixvim = {
	#extraConfigVim = ''
	    #let g:clipboard = {
		#\	'name': 'wl-clipboard',
		#\	'copy': {
		#\		'+': ['wl-copy'],
		#\		'*': ['wl-copy'],
		#\	},
		#\	'paste': {
		#\		'+': ['wl-copy'],
		#\		'*': ['wl-copy'],
		#\	},
		#\	'cache_enabled': 1
		#\ }
	#'';
	plugins.obsidian = {
	    enable = true;
	    settings.workspaces = [
		{
		  name = "General Notes";
		  path = "~/Documents/General Notes";
		}
	    ];
	};
    };

    services.redshift = {
	enable = true;
	provider = "geoclue2";
    };

}
