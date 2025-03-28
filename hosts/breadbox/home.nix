{ pkgs, localPkgs, ... }:
{
  imports = [
    ../../modules/shared-home.nix
    ../../modules/i3.nix
    #../../modules/hyprland-home.nix
    #../../modules/xmonad.nix
  ];
  home.username = "breadgirl";
  home.homeDirectory = "/home/breadgirl";

  # xdg.mimeApps = {
  #   defaultApplications = {
  #     "text/html" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/about" = "firefox.desktop";
  #     "x-scheme-handler/unknown" = "firefox.desktop";
  #   };
  # };
  services.pass-secret-service.enable = true;
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.packages = with pkgs; [
    firefox
    arandr
    discord
    lutris
    #wineWowPackages.stable
    wineWowPackages.full
    winetricks
    pkgsi686Linux.gperftools
    element-desktop
    obs-studio
    vlc
    mangohud
    vesktop
    devbox
    plexamp
    plex-desktop

    docker
    lazydocker

    localPkgs.zen-browser

    (buildFHSEnv (
      appimageTools.defaultFhsEnvArgs
      // {
        name = "fhs";
        profile = ''export FHS=1'';
        runScript = "fish";
      }
    ))
  ];

  programs.kitty.font.size = 13;
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
