{ config, pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    commands = {
      minimize = ''
        Run git diff and minimize the changes while also keeping them readable. 
	Remove all the linting and formatting changes that you have made.
	Usage: /minimize
      '';
    };
  };
}
