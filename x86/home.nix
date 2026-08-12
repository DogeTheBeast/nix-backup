{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  nur,
  ...
}:

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
    (import ../shared/sway.nix {
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
    ../shared/pi.nix
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
    pkgsUnstable.webcord
    pkgsUnstable.feishin
    pkgs.lsof
    pkgs.feh

    # dogeOnNix specifics
    pkgs.kdePackages.kdeconnect-kde
    pkgs.prismlauncher
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    # user = "doge";
    # configDir = "/home/doge/.config";
    # dataDir = "/home/doge/Syncthing";
    settings = {
      devices = {
        "OnePlus" = {
          id = "7TBB3RR-DJG3A2Y-BLUESA6-EKUMUDK-2T2QA4S-7LC5K55-ADO226S-BZVVNAZ";
        };
        "Alarm" = {
          id = "ZM6D5ZA-CQH3R65-DAY3LZT-W3IB2JG-FQMVTCM-U5Y7SXO-2ZBKAZT-TNWYQQO";
        };
      };
      folders = {
        "KeePassXC" = {
          path = "/home/doge/KeePassXC";
          id = "vhjau-lvyum";
          type = "sendreceive";
          devices = [ "OnePlus" ];
        };
        "University" = {
          path = "/home/doge/University";
          id = "huas5-xnrt6";
          type = "sendreceive";
          devices = [ "Alarm" ];
        };
      };
    };
  };

  # i3blocks
  programs.i3blocks = {
    enable = true;
    bars = {
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

  # Kitty
  # programs.kitty.font.size = 12;

  # Rofi
  programs.rofi.font = "JetBrains Mono 8";

  # Ollama
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.ollama-cuda;
  };

  # GPG
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # Sway
  wayland.windowManager.sway.config = {
    output."*".scale = "0.8";
    output = {
      HDMI-A-1 = {
        transform = "270";
      };
    };
    keybindings = lib.mkAfter {
      "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle && pkill -RTMIN+11 i3blocks";
      "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5% && pkill -RTMIN+11 i3blocks";
      "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5% && pkill -RTMIN+11 i3blocks";
      "XF86AudioPlay" = "exec playerctl play-pause";
      "XF86AudioNext" = "exec playerctl next";
      "XF86AudioPrev" = "exec playerctl previous";
    };
    bars = [
      {
        statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/bottom";
        position = "bottom";
      }
    ];
  };

  # xresources.properties = {
  #   "Xft.dpi" = 70;
  # };
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  stylix.targets.kitty.enable = false;
  stylix.targets.i3.enable = false;
  stylix.targets.yazi.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.opencode.enable = false;
}
