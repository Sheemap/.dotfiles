{ config, pkgs, nixvim, ... }:
{
    imports =
    [ # Include the results of the hardware scan.
      ../../modules/shared-home.nix
      ../../modules/hyprland.nix
      #../../modules/xmonad.nix
    ];
    home.username = "breadcat";
    home.homeDirectory = "/home/breadcat";

    home.packages = with pkgs; [
	arandr
	discord
	lutris
	wineWowPackages.stable
	winetricks
	xivlauncher
    ];

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

}
