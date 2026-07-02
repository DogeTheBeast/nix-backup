{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    extraConfig = {
      kb-row-down = "Control+j,Down";
      kb-row-up = "Control+k,Up";
      kb-element-next = "";
      kb-accept-entry = "Return,Tab";
      kb-remove-to-eol = "";
      display-drun = "Applications";
      display-window = "Windows";
      display-filebrowser = "Browse";
      display-calc = "Calc";
      modi = "drun,filebrowser,calc,window";
      show-icons = true;
      icon-theme = "Papirus";
      sidebar-mode = true;
    };
    terminal = "kitty";
    plugins = [ pkgs.rofi-calc ];
  };
}
