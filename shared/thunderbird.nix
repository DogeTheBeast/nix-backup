{ lib, config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "mail.threadpane.listview" = 1;
	"mailnews.default_sort_order" = 1;
	"layout.css.devPixelsPerPx" = "0.8";
      };
    };
  };
}
