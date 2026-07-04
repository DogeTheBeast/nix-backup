{ lib, config, pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enabled = true;
      GUI = {
        ShowTrayIcon = true;
	ApplicationTheme = "dark";
	CompactMode = true;
	MinimizeOnClose = true;
      };
      Security = {
      	LockDatabaseIdle = false;
        ClearClipboardTimeout = 30;
      };
    };
  };
}
