{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.spotify;
in
{
  options.modules.programs.spotify.enable = mkEnableOption "Enable and configure spotify";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ spotify ];
  };
}
