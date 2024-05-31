{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.ncfg.services.numlock-on-tty;
in
{
  options.ncfg.services.numlock-on-tty = {
    enable = lib.mkEnableOption "Enable numlock";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.numLockOnTty = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # /run/current-system/sw/bin/setleds -D +num < "$tty";
        ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
          for tty in /dev/tty{1..6}; do
              ${pkgs.kbd}/bin/setleds -D +num < "$tty";
          done
        '');
      };
    };
  };
}
