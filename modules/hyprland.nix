{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = ./waybar-configs/sephid86-styles.css; 
    settings = {
	mainBar = import ./waybar-configs/sephid86.nix {};
    };


  };

  services.dunst.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = "~/.config/hypr/base.conf";
      #exec-once = "waybar & hyprpaper & firefox";
    };
  };

  home.file = {
    ".config/hypr/base.conf".source = ../configs/hyprland.conf;
    #".config/waybar/config".source = ../configs/waybar.jsonc;
    #".config/waybar/styles.css".source = ../configs/waybar-styles.css;
    #".config/waybar/config".source = ../configs/waybar/archas-conf;
    #".config/waybar/styles.css".source = ../configs/waybar/archas-styles.css;
  };


}
