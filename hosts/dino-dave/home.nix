{ ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../../modules/shared-home.nix
    ../../modules/hyprland.nix
  ];
  home.username = "breadcat";
  home.homeDirectory = "/home/breadcat";
}
