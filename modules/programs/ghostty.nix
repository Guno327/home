{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.ghostty;
in
{
  options.modules.programs.ghostty.enable = mkEnableOption "Configure ghostty";

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        font-family = "FiraCode Nerd Font";
        font-size = 14;
        theme = "Dracula";
      };
    };
    wayland.windowManager.hyprland.settings = {
      bind = [ "Super, RETURN, exec, ghostty" ];
    };
  };
}
