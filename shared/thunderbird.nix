{
  lib,
  config,
  pkgs,
  ...
}:

let
  tanbanVersion = "1.9.0";
  tanban = pkgs.fetchurl {
    url = "https://github.com/DogeTheBeast/tanban/releases/download/v${tanbanVersion}/tanban.xpi";
    hash = "sha256-e/FIMbwBR6um9C4+CWf1ehKSvs9tBxzi+2/Wgat+73E=";
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
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        }
        (lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
          "layout.css.devPixelsPerPx" = "0.8";
        })
        (lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-linux") {
          "layout.css.devPixelsPerPx" = "1";
        })
      ];
      userChrome = builtins.readFile ./theme-files/thunderbird/caelus/userChrome.css;
    };
    policies.ExtensionSettings."DogeTheBeast.tanban@addons.thunderbird.net" = {
      installation_mode = "force_installed";
      install_url = "file://${tanban}";
    };
  };
}
