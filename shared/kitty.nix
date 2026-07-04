{ lib, config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include ./custom-theme.conf
    '';
    font = {
      name = "DejaVu Sans Mono";
    };
  };
  xdg.configFile."kitty/custom-theme.conf".source = ./theme-files/kitty/current-theme.conf;

}
