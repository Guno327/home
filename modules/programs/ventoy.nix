{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.ventoy;
in
{
  options.modules.programs.ventoy.enable = mkEnableOption "enable ventoy configuration";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ventoy-full-gtk
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "ventoy-gtk3-1.1.05"
    ];
  };
}
