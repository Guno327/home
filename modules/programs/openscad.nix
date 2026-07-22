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
    sha256 = "sha256-J0dkeHYlh2UFiAwubVvV8gx03RJ1BPBfqkn6Y4qUEVI=";
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
