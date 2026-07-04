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
		pkgs.prettierd
		pkgs.rustfmt

		# dogeOnNix specifics
    pkgs.kdePackages.kdeconnect-kde
		pkgs.prismlauncher
		pkgs.opencode
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    # user = "doge";
    # configDir = "/home/doge/.config";
    # dataDir = "/home/doge/Syncthing";
    settings = {
      devices = {
        "OnePlus" = { id = "7TBB3RR-DJG3A2Y-BLUESA6-EKUMUDK-2T2QA4S-7LC5K55-ADO226S-BZVVNAZ"; };
				"Alarm" = { id = "ZM6D5ZA-CQH3R65-DAY3LZT-W3IB2JG-FQMVTCM-U5Y7SXO-2ZBKAZT-TNWYQQO"; };
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

  # Zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

	# Kitty
	programs.kitty.font.size = 12;

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

  xresources.properties = {
    "Xft.dpi" = 70;
  };
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  stylix.targets.kitty.enable = false;
  stylix.targets.i3.enable = false;
  stylix.targets.yazi.enable = false;
  stylix.targets.rofi.enable = false;
}

