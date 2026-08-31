{
  pkgs,
  pkgsUnstable,
  inputs,
  config,
  ...
}:
{

  # programs.pi-coding-agent = {
  #   enable = true;
  #   package = pkgsUnstable.pi-coding-agent;
  #   context = "You are already in the working directory. You don't need to CD to any other external directory";
  #   settings = {
  #     packages = [
  #       "npm:pi-simplify"
  #       "npm:pi-plan"
  #       "npm:pi-permission-system"
  #       "npm:pi-subagents"
  #     ];
  #
  #     defaultProvider = "opencode-go";
  #     defaultModel = "deepseek-v4-flash";
  #
  #     # subagents = {
  #     # };
  #   };
  # };
  home.packages = [
    pkgsUnstable.pi-coding-agent
  ];

  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    packages = [
      "npm:pi-plan"
      "npm:@gotgenes/pi-permission-system"
      "npm:pi-subagents"
      "npm:@demigodmode/pi-web-agent"
    ];

    defaultProvider = "opencode-go";
    defaultModel = "deepseek-v4-flash";
  };

  home.file.".pi/agent/AGENTS.md".text = ''
    You are already in the working directory.
    You don't need to CD to any other external directory.
  '';

  # Permissions
  home.file.".pi/agent/extensions/pi-permission-system/config.json".text = builtins.toJSON {
    permission = {
      "*" = "allow";

      path = {
        "*" = "allow";
        "*.env" = "deny";
        "*.env.*" = "deny";
        "*.env.example" = "allow";
      };

      bash = {
        "*" = "ask";
        "rm -rf *" = "deny";
        "sudo *" = "ask";
      };

      external_directory = "ask";
    };
  };
}
