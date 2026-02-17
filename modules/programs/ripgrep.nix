{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.ripgrep;
in
{
  options.modules.programs.ripgrep.enable = mkEnableOption "Enable and alias ripgrep";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ripgrep ];
    programs.fish.shellAbbrs = {
      grep = "rg";
    };
  };
}
