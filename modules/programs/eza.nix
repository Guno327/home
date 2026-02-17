{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.eza;
in
{
  options.modules.programs.eza.enable = mkEnableOption "Enable and alias eza";
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
      ];
    };

    programs.fish.shellAbbrs = {
      ls = "eza";
      la = "eza -a";
      lt = "eza --tree";
    };
  };
}
