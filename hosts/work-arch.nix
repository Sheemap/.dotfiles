{ config, pkgs, nixvim, ... }:
{
    imports =
    [ # Include the results of the hardware scan.
      ../modules/shared-home.nix
    ];
    home.username = "breadman";
    home.homeDirectory = "/home/breadman";
    # This is needed on non-NixOS systems
    # Else we get locale warnings each time you start a new shell
    # https://github.com/nix-community/home-manager/issues/432
    programs.man.enable = false;
    home.extraOutputsToInstall = [ "man" ];

    programs.nixvim = {
	extraConfigVim = ''
	    let g:clipboard = {
		\	'name': 'copyq',
		\	'copy': {
		\		'+': ['copyq', 'tab', '&clipboard', 'copy', '-'],
		\		'*': ['copyq', 'tab', '&clipboard', 'copy', '-'],
		\	},
		\	'paste': {
		\		'+': ['copyq', 'tab', '&clipboard', 'read'],
		\		'*': ['copyq', 'tab', '&clipboard', 'read'],
		\	},
		\	'cache_enabled': 1
		\ }
	'';
    };
}
