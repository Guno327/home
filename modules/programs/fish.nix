{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.fish;
in {
  options.modules.programs.fish.enable = mkEnableOption "enable extended fish configuration";
  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        set -x NIX_PATH nixpkgs=channel:nixos-unstable
        set -x NIX_LOG info
        direnv hook fish | source
      '';
    };
  };
}
