{
  lib,
  pkgs,
  ...
}:
let
  i3blocks-contrib = pkgs.fetchFromGitHub {
    owner = "DogeTheBeast";
    repo = "i3blocks-contrib";
    rev = "master";
    sha256 = "sha256-LyIko5bqCmhcHZQoF9KqJcJ13W9sMD0wDfRE4rZou4I=";
  };
in
{
  programs.i3blocks = {
    enable = true;
    bars = {
      top = {
        mediaplayer = {
          command = "${i3blocks-contrib}/mediaplayer/mediaplayer";
          interval = 5;
        };
        volume = lib.hm.dag.entryAfter [ "mediaplayer" ] {
          command = "${i3blocks-contrib}/volume/volume";
          interval = "once";
          label = "VOL: ";
          signal = 11;
        };
        backlight = lib.hm.dag.entryAfter [ "volume" ] {
          command = "brightnessctl i | sed -n 's/.*(\\([0-9]\\+%\\)).*/\\1/p'";
          label = "Brightness: ";
          interval = 60;
          signal = 10;
        };
        iface = lib.hm.dag.entryAfter [ "backlight" ] {
          command = "${i3blocks-contrib}/iface/iface";
          ADDRESS_FAMILY = "inet";
          color = "#00FF00";
          interval = 10;
          display_wifi_name = 1;
        };
        cpu = lib.hm.dag.entryAfter [ "iface" ] {
          command = "${i3blocks-contrib}/cpu_usage/cpu_usage";
          interval = 10;
          label = "CPU: ";
        };
        memory = lib.hm.dag.entryAfter [ "cpu" ] {
          command = "${i3blocks-contrib}/memory/memory";
          label = "MEM: ";
          interval = 30;
        };
        battery = lib.hm.dag.entryAfter [ "memory" ] {
          command = "${i3blocks-contrib}/battery2/battery2";
          markup = "pango";
          interval = 30;
        };
        time = lib.hm.dag.entryAfter [ "battery" ] {
          command = "date '+%Y-%m-%d %H:%M:%S'";
          interval = 1;
        };
      };

      bottom = {
        mediaplayer = {
          command = "${i3blocks-contrib}/mediaplayer/mediaplayer";
          interval = 5;
        };
        volume = lib.hm.dag.entryAfter [ "mediaplayer" ] {
          command = "${i3blocks-contrib}/volume/volume";
          interval = "once";
          label = "VOL: ";
          signal = 11;
        };
        iface = lib.hm.dag.entryAfter [ "volume" ] {
          command = "${i3blocks-contrib}/iface/iface";
          ADDRESS_FAMILY = "inet";
          color = "#00FF00";
          interval = 10;
          display_wifi_name = 1;
        };
        cpu = lib.hm.dag.entryAfter [ "iface" ] {
          command = "${i3blocks-contrib}/cpu_usage/cpu_usage";
          interval = 10;
          label = "CPU: ";
        };
        memory = lib.hm.dag.entryAfter [ "cpu" ] {
          command = "${i3blocks-contrib}/memory/memory";
          label = "MEM: ";
          interval = 30;
        };
        time = lib.hm.dag.entryAfter [ "memory" ] {
          command = "date '+%Y-%m-%d %H:%M:%S'";
          interval = 1;
        };
      };
    };
  };
}
