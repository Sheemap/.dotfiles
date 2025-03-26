{ config, pkgs, ... }:
let
  newman-rofiThemes = pkgs.fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "f87e08300cb1c984994efcaf7d8ae26f705226fd";
    hash = "sha256-A6zIAQvjfe/XB5GZefs4TWgD+eGICQP2Abz/sQynJPo=";
  };
  dracula-rofi = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "rofi";
    rev = "459eee340059684bf429a5eb51f8e1cc4998eb74";
    hash = "sha256-Zx/+FLd5ocHg6+YkqOt67nWfeHR3+iitVm1uKnNXrzc=";
  };
in
{
  services.dunst.enable = true;

  home.file.".config/i3/config".source = ../configs/i3.conf;
  home.file.".config/i3/colors".source = ../configs/i3-ctpmocha-colors.conf;
  #home.file.".config/i3/colors".source = ../configs/i3-dracula-colors.conf;
  home.file.".config/i3/scripts/powermenu".source = ../scripts/powermenu;
  home.file.".config/rofi/powermenu.rasi".source = ../scripts/powermenu.rasi;
  home.file.".config/rofi/arc_dark_transparent_colors.rasi".source =
    ../scripts/arc_dark_transparent_colors.rasi;
  home.file.".wallpapers/pastel-1.jpg".source = ../wallpapers/pastel-1.jpg;

  programs.rofi = {
    enable = true;
    #theme = "${newman-rofiThemes}/themes/squared-everforest.rasi";
    theme = "${dracula-rofi}/theme/config1.rasi";
    #theme = "${dracula-rofi}/theme/config2.rasi";
  };

  home.packages = with pkgs; [ feh ];

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        theme = "dracula";
        icons = "material-nf";
        blocks = [
          {
            block = "bluetooth";
            mac = "F7:73:CB:4B:1B:7C";
            disconnected_format = "";
            battery_state = {
              "0..15" = "critical";
              "16..25" = "warning";
              "26..94" = "idle";
              "95..100" = "good";
            };
          }
          {
            block = "net";
            format_alt = " $device $ip ^icon_net_down $graph_down ^icon_net_up $graph_up";
          }
          {
            block = "music";
            format = " $icon {$combo.str(max_w:25,rot_interval:0.5) $play |}";
            format_alt = " $icon {$combo.str(max_w:25,rot_interval:0.5) $prev $next |}";
            click = [
              {
                button = "right";
                action = "play_pause";
              }
            ];
          }
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = " $icon $1m ";
            interval = 1;
          }
          { block = "sound"; }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %D %T') ";
            interval = 1;
          }

        ];
      };

    };

  };
}
