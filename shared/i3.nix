{ config, customModifier ? "Mod4", ... }:

{
	xsession.windowManager.i3 = {
    enable = true;
    config = rec {
			modifier = customModifier; 
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
				"${modifier}+Shift+r" = "restart";
				"${modifier}+r" = "mode resize";
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
    };
	};
}
