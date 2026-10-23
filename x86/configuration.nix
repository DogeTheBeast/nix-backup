# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, oncon
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgsUnstable,
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
  security.polkit.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "immich-2.7.5"
  ];

  # Greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
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
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        KbdInteractiveAuthentication no
        PermitTTY no
        X11Forwarding no
    '';
  };

  # Experimental features
  services.dbus.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_1;

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
    sway-audio-idle-inhibit
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

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
    package = pkgsUnstable.searxng;
    # redisCreateLocally = true;
    settings = {
      outgoing = {
        enable_http2 = false;
        useragent_suffix = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36";
      };
      server = {
        bind_address = "0.0.0.0";
        port = "8081";
        secret_key = "thisisasupersecretkey";
        public_instance = false;
        limiter = false;
      };
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

  services.hister = {
    enable = true;
    settings = {
      app = {
        search_url = "http://100.96.166.98:8081/search?q={query}";
      };
      server = {
        address = "[::]:4433";
        base_url = "http://100.96.166.98:4433";
      };
      # hotkeys.web = {
      # };
    };
  };

  # Stylix
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../shared/theme-files/wallpapers/snowflake.png;
    base16Scheme = ../shared/theme-files/base16/caelus.yaml;
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
    device = "192.168.1.210:/mnt/WD";
    fsType = "nfs";
  };

  # Sops
  sops = {
    defaultSopsFile = ../secrets/restic-password.yaml;
    age.keyFile = "/home/doge/age/secrets.txt";
    secrets = {
      restic-password = {
        sopsFile = ../secrets/restic-password.yaml;
      };

      restic-aws = {
        sopsFile = ../secrets/restic-aws.yaml;
      };

      cloudflared = {
        sopsFile = ../secrets/cloudflared.json;
        format = "json";
        key = "";
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

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git-server";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      # Pubkeys of authorised users
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPpHvGUkbDfxUlW40kRQasUSTnRWp5r0/mPWYZJwz+i ratiqnarwal@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCKdRILIFelMxcOgCoOqcklAIXc2J0jLC0MBPELaBpdSQTqCfCWk10EOeHrWwSimBHWO2inzxGqFglMPj529hH7okuIPmh/GNe3wERqJSiWqJAdtMuRCBKF4oPHKlFcxNW3LpXmV2w9eTTTa7Z18hx7yY5tTvKZ+Br8jO6Gbqgff2r84iheOBXWtT0UYY6sGvJO049U3qE6MSVkpr7LIR+MVHQsHFIPyfiE34NHhWXbbnE3pn3g/lhmZXo/EGgGEsejr++8UiO6ISxMgk6akycscMHBkBaLl+VhZHQPAVg98uqAPcMYVnnLsz2WL6yycRGdSCMW/Dbg93VcQCyJJZ5o6W8q/Kf1Ik5iS+0jF0eoXra2KzV4qjaTOfxXaC+jNNx1xj6JPbN+WtYGT10GWMmuenPR0Acd4b3GEURGdYCQi080kOb63wUNbqGq1586T/8F+x5jb1IYkLb+UqMsh5W31uT8HRD4/3/Jfs+vN07Cw9VGwI6C0fbfiXA42aMQVW8= ratiqnarwal@gmail.com"
    ];
  };

  users.groups.git = { };

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  # Cloudflared
  services.cloudflared = {
    enable = true;
    tunnels = {
      "cbfd9bb9-b165-4e18-ab46-33f5b53f83b1" = {
        ingress = {
          "photos.dogethebeast.xyz" = "http://localhost:2283";
          "music.dogethebeast.xyz" = "http://100.120.67.80:4533";
        };
        credentialsFile = "${config.sops.secrets.cloudflared.path}";

        default = "http_status:404";
      };
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
