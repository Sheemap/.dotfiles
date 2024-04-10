{ config, pkgs, nixvim, ... }:
{
    imports =
    [ # Include the results of the hardware scan.
      ../../modules/shared-home.nix
    ];
    home.username = "breadman";
    home.homeDirectory = "/home/breadman";
    # This is needed on non-NixOS systems
    # Else we get locale warnings each time you start a new shell
    # https://github.com/nix-community/home-manager/issues/432
    programs.man.enable = false;
    home.extraOutputsToInstall = [ "man" ];

    home.packages = with pkgs; [
	slack
	mongodb-compass
    ];

    obsidian = {
	enable = true;
	settings.workspaces = [
	    {
	      name = "General Notes";
	      path = "~/Documents/General Notes";
	    }
	];
    };

}
