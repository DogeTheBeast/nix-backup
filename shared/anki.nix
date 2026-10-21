{
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.anki = {
    enable = true;
    theme = "dark";
  };
}
