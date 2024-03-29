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
}
