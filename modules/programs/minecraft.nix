{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.minecraft;
in
{
  options.modules.programs.minecraft.enable = mkEnableOption "Install minecraft";

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
    };

    home.packages = with pkgs; [ stable.prismlauncher ];
  };
}
