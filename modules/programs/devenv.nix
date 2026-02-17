{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.dev;
in
{
  options.modules.programs.dev.enable = mkEnableOption "enable configuration for devenv";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
    ];

    programs.direnv = {
      enable = true;
    };
  };
}
