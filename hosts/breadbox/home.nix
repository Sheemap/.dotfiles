{ config, pkgs, nixvim, ... }:
{
    imports =
    [ # Include the results of the hardware scan.
      ../../modules/shared-home.nix
      ../../modules/hyprland.nix
    ];
    home.username = "breadcat";
    home.homeDirectory = "/home/breadcat";

    home.packages = with pkgs; [
	webcord
	wofi
	wl-clipboard
    ];

    programs.nixvim = {
	extraConfigVim = ''
	    let g:clipboard = {
		\	'name': 'wl-clipboard',
		\	'copy': {
		\		'+': ['wl-copy'],
		\		'*': ['wl-copy'],
		\	},
		\	'paste': {
		\		'+': ['wl-copy'],
		\		'*': ['wl-copy'],
		\	},
		\	'cache_enabled': 1
		\ }
	'';
    };
}
