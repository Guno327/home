{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.openscad;
  bosl2 = pkgs.fetchFromGitHub {
    owner = "BelfrySCAD";
    repo = "BOSL2";
    rev = "master";
    sha256 = "sha256-ErSJxw1hLlnyUQCXBChwBrN9kS6+l4KXYvu9bBO1m6w=";
  };
in
{
  options.modules.programs.openscad.enable = mkEnableOption "Install and configure openscad";

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ openscad ];
      file.".local/share/OpenSCAD/libraries/BOSL2".source = bosl2;
    };
  };
}
