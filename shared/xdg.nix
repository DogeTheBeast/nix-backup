{ lib, config, pkgs, ... }:

{
  # XDG
  xdg = {
    mime.enable = true;

    desktopEntries.zathura = {
      name = "Zathura";
      exec = "${pkgs.zathura}/bin/zathura";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "zathura.desktop" ];
	"image/gif" = [ "feh.desktop" ];
	"image/jpeg" = [ "feh.desktop" ];
	"image/png" = [ "feh.desktop" ];
	"image/tiff" = [ "feh.desktop" ];
	"image/webp" = [ "feh.desktop" ];
	"audio/aac" = [ "vlc.desktop" ];
	"audio/mpeg" = [ "vlc.desktop" ];
	"audio/ogg" = [ "vlc.desktop" ];
	"audio/wav" = [ "vlc.desktop" ];
	"audio/webm" = [ "vlc.desktop" ];
	"audio/3gpp" = [ "vlc.desktop" ];
	"video/x-msvideo" = [ "vlc.desktop" ];
	"video/mp4" = [ "vlc.desktop" ];
	"video/mpeg" = [ "vlc.desktop" ];
	"video/x-matroska" = [ "vlc.desktop" ];
	"video/ogg" = [ "vlc.desktop" ];
	"video/mp2t" = [ "vlc.desktop" ];
	"video/3gpp" = [ "vlc.desktop" ];
	"text/css" = [ "nvim.desktop" ];
	"text/csv" = [ "nvim.desktop" ];
	"text/js" = [ "nvim.desktop" ];
	"text/json" = [ "nvim.desktop" ];
	"text/markdown" = [ "nvim.desktop" ];
	"text/plain" = [ "nvim.desktop" ];
      };
    };
  };
}
