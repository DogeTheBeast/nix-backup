{
  lib,
  config,
  pkgs,
  ...
}:

let
  tanbanVersion = "1.7.0";
  tanban = pkgs.fetchurl {
    url = "https://github.com/DogeTheBeast/tanban/releases/download/v${tanbanVersion}/tanban.xpi";
    hash = "sha256-Z/kaiIvg9XGLXborOJkckUG0GWXMcdLZJ06/KgVsbl0=";
  };
in
{
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = lib.mkMerge [
        {
          "mail.threadpane.listview" = 1;
          "mailnews.default_sort_order" = 1;
        }
        (lib.mkIf (pkgs.system == "x86_64-linux") {
          "layout.css.devPixelsPerPx" = "0.8";
        })
        (lib.mkIf (pkgs.system == "aarch64-linux") {
          "layout.css.devPixelsPerPx" = "1";
        })
      ];
    };
    policies.ExtensionSettings."DogeTheBeast.tanban@addons.thunderbird.net" = {
      installation_mode = "force_installed";
      install_url = "file://${tanban}";
    };
  };
}
