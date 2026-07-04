{ lib, config, pkgs, ... }:
let 
  yazi-flexoki-dark = pkgs.fetchFromGitHub {
    owner = "gosxrgxx";
    repo = "flexoki-dark.yazi";
    rev = "main"; 
    sha256 = "sha256-z8USdFAWqDl+8+aM83Hy0Wjjkdq62LC5PwcVpDMOWWY=";
  };
in
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
