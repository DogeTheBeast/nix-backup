{ pkgs, nix-pi-agent, ... }:
{
  programs.pi = {
    enable = true;

    settings = {
      providers = {
        local = {
          provider = "ollama";
          model = "codellama";
          baseUrl = "http://100.96.166.98:11434";
        };
      };
    };

  };
}
