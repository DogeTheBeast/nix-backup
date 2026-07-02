{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    flavors = { flexoki-dark = yazi-flexoki-dark; };
    theme.flavor.dark = "flexoki-dark";

    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };

    keymap = {
      mgr.prepend_keymap = [
        { run = "plugin smart-enter"; on = [ "l" ]; }
      ];
    };
  };
}
