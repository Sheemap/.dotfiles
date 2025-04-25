{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.openobserve;
in
{
  options = {
    openobserve.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.firefox ];

    systemd.services.openobserve = {
      enable = true;

      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.openobserve}/bin/openobserve";
        EnvironmentFile = "/etc/nixos/openobserve.env";
      };

      # environment = {
      #   ZO_ROOT_USER_EMAIL = "root@root.test";
      #   ZO_ROOT_USER_PASSWORD = "toor";
      # };

      restartIfChanged = true;
    };
  };
}
