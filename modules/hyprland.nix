{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
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
    ".config/waybar/config".source = ../configs/waybar.jsonc;
    ".config/waybar/styles.css".source = ../configs/waybar-styles.css;
  };


}
