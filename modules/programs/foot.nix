{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.foot;
in
{
  options.modules.programs.foot.enable = mkEnableOption "Configure foot";

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
        };

        mouse = {
          hide-when-typing = true;
        };

        csd = {
          preferred = "none";
        };
      };
    };
    wayland.windowManager.hyprland.settings = {
      bind = [ "Super, RETURN, exec, foot -e fish -c 'exec fish'" ];
    };
  };
}
