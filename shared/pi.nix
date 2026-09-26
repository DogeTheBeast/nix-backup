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
      "npm:pi-compass"
      "https://github.com/ayghri/i-have-adhd"
      "npm:@upstash/context7-pi"
      "npm:pi-mcp-adapter"
    ];

    defaultProvider = "opencode-go";
    defaultModel = "deepseek-v4-flash";
  };

  home.file.".pi/agent/AGENTS.md".text = ''
    	 # Working directory discipline                                                                                                                                                                                                       
                                                                                                                                                                                                                                            
       Every bash command already runs in the project root — the harness passes the                                                                                                                                                         
       working directory itself. Never start a bash command with `cd`.                                                                                                                                                                      
                                                                                                                                                                                                                                            
       Wrong:  cd /home/doge/packages/phaze && ./gradlew assembleDebug                                                                                                                                                                      
       Right:  ./gradlew assembleDebug                                                                                                                                                                                                      
                                                                                                                                                                                                                                            
       If you start writing `cd ... &&`, delete it before sending: the shell is                                                                                                                                                             
       already in the correct directory, so the prefix is redundant noise.
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

  # MCP
  # home.file.".pi/agent/mcp.json".text = builtins.toJSON {
  # };

  # home.file.".pi/agent/pi-jev-browser.config.json".text = builtins.toJSON {
  #   typesafe = {
  #     baseUrl = "https://openrouter.ai/api/alpha/decisions";
  #   };
  # };
}
