{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = lib.mkMerge [
      (rec {
        modifier = "Mod4";
        fonts = {
          names = [ "JetBrains Mono NL" ];
        };
        keybindings = {
          "${modifier}+Return" = "exec kitty";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "exec rofi -show drun";
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
          "${modifier}+Shift+r" = "exec swaymsg reload";
          "${modifier}+r" = "mode resize";
          "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle && pkill -RTMIN+11 i3blocks";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5% && pkill -RTMIN+11 i3blocks";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5% && pkill -RTMIN+11 i3blocks";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
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
      })

      # X86
      (lib.mkIf (pkgs.system == "x86_64-linux") {
        output."*".scale = "0.8";

        output.HDMI-A-1 = {
          transform = "270";
        };

        keybindings = {
          "Mod4+grave" =
            ''exec sh -c 'grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy' '';
        };

        bars = [
          {
            statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/bottom";
            position = "bottom";
          }
        ];
      })

      # ARM
      (lib.mkIf (pkgs.system == "aarch64-linux") {
        output."*".scale = "1.3";
        keybindings = lib.mkAfter {
          "Mod4+less" =
            ''exec sh -c 'grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy' '';
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5% && pkill -RTMIN+10 i3blocks";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%- && pkill -RTMIN+10 i3blocks";
        };
        bars = [
          {
            statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/top";
            position = "top";
          }
        ];
      })
    ];
  };

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.dunst}/bin/dunstify 'Locking in 30 seconds'";
        }
        {
          timeout = 330;
          command = lock;
        }
        {
          timeout = 345;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 350;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
}
