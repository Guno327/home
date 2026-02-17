{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.devenv;
in {
  options.modules.programs.devenv.enable = mkEnableOption "enable configuration for devenv";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
    ];

    programs.direnv = {
      enable = true;
    };
  };
}
