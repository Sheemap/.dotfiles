{ config, pkgs, ... }:
let
  i3catppuccin = pkgs.fetchgit {
    url = "https://github.com/catppuccin/i3";
    rev = "cd6b5017850084d5b40ef9f4eeac5a6d95779939";
    hash = "sha256-91GsedHF6xM1jmutZX/xdNtGFDrGerRSaRVh29CXt8U=";
  };
in 
{
    services.dunst.enable = true;

    home.file.".config/i3/config".source = ../configs/i3.conf;
    home.file.".config/i3/colors".source = ../configs/i3-colors.conf;
    home.file.".config/i3/catppuccin".source = "${i3catppuccin}/themes/catppuccin-mocha";
    home.file.".config/i3/scripts/powermenu".source = ../scripts/powermenu;
    home.file.".config/rofi/powermenu.rasi".source = ../scripts/powermenu.rasi;
    home.file.".wallpapers/pastel-1.jpg".source = ../wallpapers/pastel-1.jpg;

    home.packages = with pkgs; [
	catppuccin
	feh
    ];

    # Needs work
    # Also want to adjust the bar theme
    programs.i3status-rust = {
	enable = true;
	bars = {
	    default = {
		theme = "ctp-mocha";
		icons = "awesome5";
		blocks = [
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
		      {
			block = "sound";
		      }
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
