{ config, pkgs, ... }:
{
    services.dunst.enable = true;

    home.file.".config/i3/config".source = ../configs/i3.conf;

    # Needs work
    # Also want to adjust the bar theme
    programs.i3status-rust = {
	enable = true;
	bars = {
	    default = {
		theme = "ctp-mocha";
		icons = "awesome6";
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
			format = " $timestamp.datetime(f:'%a %d/%m %R') ";
			interval = 5;
		      }

		];
	    };

	};

    };
}
