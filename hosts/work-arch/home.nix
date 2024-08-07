{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
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
    lazydocker
    devbox
  ];

  programs.fish.shellAliases = {
    db = "devbox";
  };

  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  programs.kitty.font.size = 12;
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings.workspaces = [
      {
        name = "General Notes";
        path = "~/Documents/General Notes";
      }
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "breadman"
  ];

}
