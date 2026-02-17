{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zoxide;
in
{
  options.modules.programs.zoxide.enable = mkEnableOption "Enable and alias zoxide";

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish.shellAbbrs = {
      cd = "z";
    };
  };
}
