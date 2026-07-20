{
  programs.pi-coding-agent = {
    enable = true;

    package = inputs.pi-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;

    mutableDir = true;

    models = {
      providers = {
        local = {
          provider = "ollama";
          model = "codellama";
          baseUrl = "http://100.96.166.98:11434";
        };
      };
    };

    extensions = [
    ];
  };
}
