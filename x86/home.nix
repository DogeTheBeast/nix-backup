{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  nur,
  ...
}:

{
  home.username = "doge";
  home.homeDirectory = "/home/doge";

  imports = [
    ../shared/dunst.nix
    ../shared/git.nix
    ../shared/i3blocks.nix
    ../shared/keepassxc.nix
    ../shared/kitty.nix
    ../shared/librewolf.nix
    ../shared/nixvim.nix
    ../shared/ollama.nix
    ../shared/pi.nix
    ../shared/rofi.nix
    ../shared/stylix.nix
    ../shared/sway.nix
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
    pkgs.pre-commit
    pkgs.prettier
    pkgs.nodejs

    # dogeOnNix specifics
    pkgs.kdePackages.kdeconnect-kde
    pkgs.prismlauncher
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
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
      };
    };
  };

  # GPG
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
