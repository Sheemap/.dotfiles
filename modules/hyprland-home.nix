{ pkgs, ... }:
let
  wofi-catppuccin = pkgs.fetchFromGitHub {
    owner = "quantumfate";
    repo = "wofi";
    rev = "6c37e0f65b9af45ebe680e3e0f5131f452747c6f";
    hash = "sha256-zQGiF/8WZ15ZlQVVgxuQq4qatinxMx2Y6Xl5Zcuhp7Y=";
  };
in
{

  programs.waybar = {
    enable = true;
    style = ./waybar-configs/sephid86-styles.css;
    settings = {
      mainBar = import ./waybar-configs/sephid86.nix { };
    };

  };

  services.dunst.enable = true;
  programs.wofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = "~/.config/hypr/base.conf";
      #exec-once = "waybar & hyprpaper & firefox";
    };
  };

  home.file = {
    ".config/hypr/base.conf".source = ../configs/hyprland.conf;
    ".config/wofi/style.css".source = "${wofi-catppuccin}/src/mocha/style.css";
    #".config/waybar/config".source = ../configs/waybar.jsonc;
    #".config/waybar/styles.css".source = ../configs/waybar-styles.css;
    #".config/waybar/config".source = ../configs/waybar/archas-conf;
    #".config/waybar/styles.css".source = ../configs/waybar/archas-styles.css;
  };

}
