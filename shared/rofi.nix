{
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.rofi = lib.mkMerge [
    {
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
      theme = "glue_pro_blue.rasi";
    }
    (lib.mkIf (pkgs.system == "x86_64-linux") {
      font = "JetBrains Mono 8";
    })
    (lib.mkIf (pkgs.system == "aarch64-linux") {
      font = "JetBrains Mono 12";
    })
  ];
}
