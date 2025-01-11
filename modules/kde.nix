{ pkgs, localPackages, ... }:
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.enable = true; # optional

  # Comment if using X11
  services.displayManager.sddm.wayland.enable = true;

  # Uncomment to use X11
  # services.displayManager.defaultSession = "plasmax11";
}
