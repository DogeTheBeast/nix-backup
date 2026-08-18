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
    ../shared/pi.nix
    ../shared/rofi.nix
    ../shared/obs.nix
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
    pkgs.nodejs_22
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
    pkgs.figma-linux
    pkgs.lsof
    pkgs.feh
    pkgs.opensrc
    pkgs.jq

    # Arm exclusive
    pkgs.fooyin
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "OnePlus" = {
          id = "7TBB3RR-DJG3A2Y-BLUESA6-EKUMUDK-2T2QA4S-7LC5K55-ADO226S-BZVVNAZ";
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

  # Cursor theme
  home.pointerCursor = {
    enable = true;
    x11.enable = true;
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 48;
  };

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
