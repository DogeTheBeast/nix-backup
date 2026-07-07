{ lib, config, pkgs, pkgsUnstable, nur, ...}:

let
  i3blocks-contrib = pkgs.fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = "master"; 
    sha256 = "sha256-iY9y3zLw5rUIHZkA9YLmyTDlgzZtIYAwWgHxaCS1+PI=";
  };
in
{
  home.username = "doge";
  home.homeDirectory = "/home/doge";

	imports = [
		( import ../shared/i3.nix {
			customModifier = "Mod4";
			inherit config;
		})
		../shared/dunst.nix
		../shared/git.nix
		../shared/keepassxc.nix
		../shared/kitty.nix
		../shared/librewolf.nix
		../shared/nixvim.nix
		../shared/opencode.nix
		../shared/rofi.nix
		../shared/thunderbird.nix
		../shared/xdg.nix
		../shared/yazi.nix
		../shared/zoxide.nix
		../shared/zsh.nix
	];

  home.packages = [
    pkgs.python3
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

	# Overrides

	# Kitty
	programs.kitty.font.size = 16;

	# Rofi
	programs.rofi.font = "JetBrains Mono 12";

	# I3
	xsession.windowManager.i3.config = {
		keybindings = lib.mkAfter {
				"XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5% && pkill -RTMIN+10 i3blocks";
				"XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%- && pkill -RTMIN+10 i3blocks";
				"XF86AudioMute" = "exec pactl set-sink-mute 0 toggle && pkill -RTMIN+11 i3blocks";
				"XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5% && pkill -RTMIN+11 i3blocks";
				"XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5% && pkill -RTMIN+11 i3blocks";
				"XF86AudioPlay" = "exec playerctl play-pause";
				"XF86AudioNext" = "exec playerctl next";
				"XF86AudioPrev" = "exec playerctl previous";
		};
		bars = [
			{
				statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/top";
				position = "top";
			}
		];
	};


  stylix.targets.kitty.enable = false;
  stylix.targets.i3.enable = false;
  stylix.targets.yazi.enable = false;
	stylix.targets.rofi.enable = false;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}

