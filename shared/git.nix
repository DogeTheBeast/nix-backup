{
  lib,
  config,
  pkgs,
  ...
}:

{
  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ratiq Narwal";
        email = "ratiqnarwal@gmail.com";
      };
      init.defaultBranch = "main";
    };
    ignores = [
      "tags"
    ];
  };
}
