{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#777777";
    };
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "eastwood";
    };

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      weather = "curl \'wttr.in/$1\'";
    };

		plugins = [
			{
        name = "zsh-nix-shell";
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
				src = pkgs.zsh-nix-shell;
      }
		];

		initContent = lib.mkOrder 1500 ''
			nix_prompt() {
				if [[ -n "$IN_NIX_SHELL" ]]; then
					echo "($NIX_SHELL_NAME) "
				fi
			}

			PS1='%F{green}$(nix_prompt)%f'$PS1
		'';

    history.size = 10000;
  };
}
