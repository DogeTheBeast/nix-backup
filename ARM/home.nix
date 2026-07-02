{ lib, config, pkgs, pkgsUnstable, nur, ...}:

let
  i3blocks-contrib = pkgs.fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = "master"; 
    sha256 = "sha256-iY9y3zLw5rUIHZkA9YLmyTDlgzZtIYAwWgHxaCS1+PI=";
  };
  yazi-flexoki-dark = pkgs.fetchFromGitHub {
    owner = "gosxrgxx";
    repo = "flexoki-dark.yazi";
    rev = "main"; 
    sha256 = "sha256-z8USdFAWqDl+8+aM83Hy0Wjjkdq62LC5PwcVpDMOWWY=";
  };
in
{
  home.username = "doge";
  home.homeDirectory = "/home/doge";

  home.packages = [
    pkgs.python313
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake
    pkgs.git
    pkgs.scrot
    pkgs.xclip
    pkgs.playerctl
    pkgs.zathura
    pkgs.libreoffice-qt
    pkgs.htop
    pkgs.vlc
    pkgs.sshfs
    pkgs.bat
    pkgs.ripgrep
    pkgs.fd
    pkgs.universal-ctags
    pkgs.webcord
    pkgsUnstable.feishin
    pkgs.figma-linux
    pkgs.lsof
    pkgs.feh
    pkgs.prettierd
    pkgs.rustfmt
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "OnePlus" = { id = "7TBB3RR-DJG3A2Y-BLUESA6-EKUMUDK-2T2QA4S-7LC5K55-ADO226S-BZVVNAZ"; };
      };
      folders = {
	"KeePassXC" = {
	  path = "/home/doge/KeePassXC";
	  id = "vhjau-lvyum";
	  type = "sendreceive";
	  devices = [ "OnePlus" ];
	};
      };
    };
  };

  # I3
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      fonts = {
        names = [ "JetBrains Mono NL" ];
      };
      keybindings = {
        "${modifier}+Return" = "exec kitty";
        "${modifier}+q" = "kill";
        "${modifier}+space" = "exec rofi -show drun -theme glue_pro_blue";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+semicolon" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";
	"${modifier}+Shift+space" = "floating toggle";
	"${modifier}+1" = "workspace number 1";
	"${modifier}+2" = "workspace number 2";
	"${modifier}+3" = "workspace number 3";
	"${modifier}+4" = "workspace number 4";
	"${modifier}+5" = "workspace number 5";
	"${modifier}+6" = "workspace number 6";
	"${modifier}+7" = "workspace number 7";
	"${modifier}+8" = "workspace number 8";
	"${modifier}+9" = "workspace number 9";
	"${modifier}+b" = "workspace Browser";
	"${modifier}+e" = "workspace Editor";
	"${modifier}+d" = "workspace Ranger";
	"${modifier}+s" = "workspace Music";
	"${modifier}+m" = "workspace Mail";
	"${modifier}+Shift+1" = "move container to workspace number 1";
	"${modifier}+Shift+2" = "move container to workspace number 2";
	"${modifier}+Shift+3" = "move container to workspace number 3";
	"${modifier}+Shift+4" = "move container to workspace number 4";
	"${modifier}+Shift+5" = "move container to workspace number 5";
	"${modifier}+Shift+6" = "move container to workspace number 6";
	"${modifier}+Shift+7" = "move container to workspace number 7";
	"${modifier}+Shift+8" = "move container to workspace number 8";
	"${modifier}+Shift+9" = "move container to workspace number 9";
	"${modifier}+Shift+b" = "move container to workspace Browser";
	"${modifier}+Shift+e" = "move container to workspace Editor";
	"${modifier}+Shift+d" = "move container to workspace Ranger";
	"${modifier}+Shift+s" = "move container to workspace Music";
	"${modifier}+Shift+m" = "move container to workspace Mail";
	"${modifier}+Shift+r" = "restart";
	"${modifier}+r" = "mode resize";
	"XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5% && pkill -RTMIN+10 i3blocks";
	"XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%- && pkill -RTMIN+10 i3blocks";
	"XF86AudioMute" = "exec pactl set-sink-mute 0 toggle && pkill -RTMIN+11 i3blocks";
	"XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5% && pkill -RTMIN+11 i3blocks";
	"XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5% && pkill -RTMIN+11 i3blocks";
	"XF86AudioPlay" = "exec playerctl play-pause";
	"XF86AudioNext" = "exec playerctl next";
	"XF86AudioPrev" = "exec playerctl previous";
	"${modifier}+less" = "exec scrot ~/temp/%b%d::%H%M%S.png -s -e 'xclip -selection clipboard -t image/png -i $f'";
      };
      
      modes = {
        resize = {
	  h = "resize shrink width 10 px or 10 ppt";
	  j = "resize grow height 10 px or 10 ppt";
	  k = "resize shrink height 10 px or 10 ppt";
	  l = "resize grow width 10 px or 10 ppt";
	  Return = "mode default";
	  Escape = "mode default";
	};
      };
      window.border = 4;
      window.titlebar = false;
      terminal = "kitty";
      bars = [
        {
	  statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/top";
	  position = "top";
	}
      ];
    };
  };

  # i3Blocks
  programs.i3blocks = {
    enable = true;
    bars = {
      top = {
        mediaplayer =  {
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
        battery =  lib.hm.dag.entryAfter [ "memory" ] {
	  command = "${i3blocks-contrib}/battery2/battery2";
	  markup = "pango";
	  interval = 30;
	};
        time = lib.hm.dag.entryAfter [ "battery" ] {
          command = "date '+%Y-%m-%d %H:%M:%S'";
  	  interval = 1;
        };
      };
    };
  };

  # Cursor theme
  home.pointerCursor = {
    enable = true;
    x11.enable = true;
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 48;
  };

  stylix.targets.kitty.enable = false;
  stylix.targets.i3.enable = false;
  stylix.targets.yazi.enable = false;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}

