{ lib, config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = "350";
        height = "300";
        offset = "50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#285577";
        background = "#050c10FF";
        max_icon_size = 128;
      };
      urgency_normal = lib.mkForce {
        background = "#050C10FF";
      };
    };
  };
}
