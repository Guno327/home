{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.fish;
in
{
  options.modules.programs.fish.enable = mkEnableOption "enable extended fish configuration";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      procs
      devenv
    ];

    programs = {
      ripgrep.enable = true;
      direnv.enable = true;

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        extraOptions = [
          "-l"
          "--icons"
          "--git"
        ];
      };

      fish = {
        enable = true;
        shellAbbrs = {
          "ls" = "eza";
          "la" = "eza -a";
          "lt" = "eza --tree";
          "grep" = "rg";
          "lxc" = "incus";
          "lxd" = "incus admin";
        };

        shellInit = ''
          direnv hook fish | source
          eval $(zoxide init fish --cmd cd)
        '';
      };
    };
  };
}
