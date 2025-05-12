  # NOTE: This service doesnt actually work, but Im committing it to keep note of a home-manager service syntax that works.
{ config, pkgs, lib, ... }:
let
  cfg = config.services.twingate;
  home-dir = config.home.homeDirectory;
in
{
  options = {
    services.twingate.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.twingate = {

      Unit = {
        Description = "Twingate client";
        After = ["network-pre.target" "NetworkManager.service" "systemd-resolved.service"];
        Wants = ["network-pre.target"];
      };

      Service = {
        ExecStart = "${pkgs.twingate}/bin/twingated ${home-dir}/.config/twingate/config.json";
        Restart = "on-failure";
        ProtectSystem = "full";
        NoNewPrivileges = true;
        WorkingDirectory = "${home-dir}/.local/share/twingate";
      };
    };
  };
}
