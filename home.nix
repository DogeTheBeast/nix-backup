{ lib, config, pkgs, pkgsUnstable, ...}:

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
    pkgs.neovim
    pkgs.yazi
    pkgs.zathura
    pkgs.rofi
    pkgs.libreoffice-qt
    pkgs.htop
    pkgs.syncthing
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kitty
    pkgs.keepassxc
    pkgs.librewolf
    pkgs.thunderbird
    pkgs.vlc
    pkgs.sshfs
    pkgs.bat
    pkgs.ripgrep
    pkgs.fd
		pkgs.universal-ctags
		pkgs.webcord
    pkgsUnstable.feishin
		pkgs.prismlauncher
		pkgs.openjdk25
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

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#777777";
    };
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "eastwood";
    };

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      weather = "curl \'wttr.in/$1\'";
    };

		plugins = [
		  {
				name = "autoswitch-virtualenv";
				file = "autoswitch-virtualenv.plugin.zsh";
				src = pkgs.callPackage ./pkgs/autoswitch-virtualenv.nix {};
			}
			{
        name = "zsh-nix-shell";
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
				src = pkgs.zsh-nix-shell;
      }
		];

		initContent = lib.mkOrder 1500 ''
			nix_prompt() {
				if [[ -n "$IN_NIX_SHELL" ]]; then
					echo "($NIX_SHELL_NAME) "
				fi
			}

			PS1='%F{green}$(nix_prompt)%f'$PS1
		'';

    history.size = 10000;
  };

  # Zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

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
}

