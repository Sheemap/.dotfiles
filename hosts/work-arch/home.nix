{ pkgs, config, nixgl, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../../modules/shared-home.nix
    ../../modules/i3.nix
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
  ];

  nixGL = {
    packages = nixgl.packages;
  };

  programs.kitty = {
    font.size = 12;
    package = (config.lib.nixGL.wrap pkgs.kitty);
    settings = {
      shell = "${pkgs.fish}/bin/fish";
    };
  };

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

  services.nextcloud-client = {
    enable = false;
    # Ran into some GL weirdness, unable application not starting
    # Adding this env var to launch allows it to start and sync, but breaks UI
    package = pkgs.writeShellScriptBin "nextcloud" ''
      QT_XCB_GL_INTEGRATION=none ${pkgs.nextcloud-client}/bin/nextcloud
    '';
  };
}
