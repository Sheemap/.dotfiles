{ pkgs, lib, localPkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../../modules/shared-home.nix
    #../../modules/hyprland-home.nix
    #../../modules/xmonad.nix
  ];
  home.username = "breadgirl";
  home.homeDirectory = "/home/breadgirl";

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.file.".config/kitty/kitty.conf".source = ../../configs/kitty.conf;

  home.packages = with pkgs; [
    firefox
    arandr
    #discord
    #wineWowPackages.stable
    wineWowPackages.full
    winetricks
    pkgsi686Linux.gperftools
    #element-desktop
    obs-studio
    vlc
    mangohud
    #vesktop
    devbox
    picard

    docker
    lazydocker
  ];

  programs.kitty.font.size = 13;
  programs.kitty.enable = lib.mkForce false;
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
