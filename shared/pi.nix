{
  pkgs,
  inputs,
  config,
  ...
}:
{

  programs.pi.coding-agent = {
    enable = true;
    rules = "You are already in the working directory. You don't need to CD to any other directory";
    extensions = [
      "npm:pi-simplify"
      "npm:pi-plan"
      "npm:pi-permission-system"
      "npm:pi-subagents"
    ];
    # skills = [ ./skills/my-skill ];
    # models = ./models.json;
    # settings.model = "gpt-5";
    # environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.pi/agent";
    # environment.OPENAI_API_KEY.file = config.sops.secrets.openai-api-key.path;
  };
  home.file.".pi/agent/extensions/pi-permission-system/config.json".text = builtins.toJSON {
    permissions = {
      path = {
        "*" = "allow";
        "*.env" = "ask";
      };
      bash = {
        "*" = "ask";
      };
    };
  };
}
