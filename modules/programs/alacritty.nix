{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.alacritty;
in {
  options.modules.programs.alacritty.enable = mkEnableOption "Configure alacritty";
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      theme = "catppuccin_mocha";
    };
  };
}
