{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.bash;
in
{
  options.modules.programs.bash.enable = mkEnableOption "enable extended bash configuration";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blesh
      procs
      devenv
    ];

    programs = {
      ripgrep.enable = true;
      direnv.enable = true;

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        extraOptions = [
          "-l"
          "--icons"
          "--git"
        ];
      };

      bash = {
        enable = true;

        shellAliases = {
          "ls" = "eza";
          "la" = "eza -a";
          "lt" = "eza --tree";
          ".." = "cd ..";
          "..." = "cd ../..";
          "grep" = "rg";
          "ps" = "procs";
        };

        initExtra = ''
          source "$(blesh-share)"/ble.sh
          eval "$(direnv hook bash)"
          eval "$(zoxide init bash --cmd cd)"
        '';
      };
    };
  };
}
