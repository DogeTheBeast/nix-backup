# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, oncon
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  sops-nix,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1p1";

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # TEMP
  nixpkgs.config.allowUnfree = true;
  services.pcscd.enable = true;

  # Greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # services.open-webui = {
  #   enable = true;
  #   host = "0.0.0.0";
  #   environment = {
  #     HOME = "/home/doge/";
  #     OLLAMA_BASE_URL = "http://localhost:11434";
  #     WEBUI_AUTH = "False";
  #   };
  # };

  services.tailscale = {
    enable = true;
    serve = {
      enable = true;
      services = {
        immich = {
          endpoints = {
            "tcp:443" = "http://localhost:2283";
          };
          advertised = true;
        };
      };
    };
  };

  services.openssh = {
    enable = true;
  };

  # Experimental features
  services.dbus.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "dogeOnNix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "8.8.8.8" ];

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  environment.pathsToLink = [ "/libexec" ];

  # Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    grim
    slurp
    swaylock
    swayidle
    vim
    wget
    acpi
    iw
    brightnessctl
    python3
    alsa-utils
    pulseaudio
    sysstat
    kitty
    libinput
  ];

  # services.xserver.displayManager.setupCommands = ''
  #   ${pkgs.xorg.xrandr}/bin/xrandr \
  #     --output DP-4 --primary \
  #     --output HDMI-0 --rotate left --right-of DP-4
  # '';

  # Configure keymap in X11
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  system.activationScripts.disableAutoMute = ''
    ${pkgs.alsa-utils}/bin/amixer -c 2 sset "Auto-Mute Mode" Disabled 
  '';

  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.doge = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    home = "/home/doge";
    packages = with pkgs; [
      git
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Environment Variables
  environment.variables.EDITOR = "nvim";

  # Searxng
  services.searx = {
    enable = true;
    # redisCreateLocally = true;
    settings.server = {
      bind_address = "0.0.0.0";
      port = "8081";
      secret_key = "thisisasupersecretkey";
      public_instance = false;
      limiter = false;
    };
    limiterSettings.botdetection = {
      ip_limit = {
        filter_link_local = false;
        link_token = false;
      };
      ip_lists.pass_ip = [
        "100.109.48.104"
      ];
    };
    settings.search.formats = [
      "html"
      "json"
    ];
  };

  # Stylix
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../shared/theme-files/wallpapers/snowflake.png;
    base16Scheme = ../shared/theme-files/theme.yaml;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Backup systemd
  systemd.services.nixos-backup = {
    description = "Backup NixOS config to GitHub";
    script = ''
      			REPO_DIR="/home/doge/nixos-config/"
      			cd "$REPO_DIR"
      			git add -A
      			if ! git diff --cached --quiet; then
      					git commit -m "Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"
      					git push origin master
      			fi
      		'';
    serviceConfig = {
      Type = "oneshot";
      User = "doge";
    };
    path = [
      pkgs.git
      pkgs.bash
      pkgs.openssh
    ];
  };

  systemd.timers.nixos-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Immich
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/WD/collection/Photos/";
  };

  # NFS
  fileSystems."/mnt/WD" = {
    device = "192.168.100.100:/mnt/WD";
    fsType = "nfs";
  };

  # Sops
  sops = {
    defaultSopsFile = /home/doge/secrets/restic-password.yaml;
    age.keyFile = "/home/doge/age/secrets.txt";
    secrets = {
      restic-password = {
        sopsFile = /home/doge/secrets/restic-password.yaml;
      };

      restic-aws = {
        sopsFile = /home/doge/secrets/restic-aws.yaml;
      };
    };
  };

  # Restic
  services.restic.backups.photos = {
    paths = [ "/mnt/WD/collection/Photos/" ];
    repository = "s3:https://s3.amazonaws.com/photos-restic-s3";
    initialize = true;
    passwordFile = config.sops.secrets.restic-password.path;
    environmentFile = config.sops.secrets.restic-aws.path;

    pruneOpts = [
      "--keep-last 3"
    ];
    timerConfig = {
      OnCalendar = "weekly";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    8080
    11434
    49154
  ];
  networking.firewall.allowedUDPPorts = [ 49154 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
