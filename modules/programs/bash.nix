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

    home.file.".blerc" = {
      enable = true;
      force = true;
      text = ''
        ble-face auto_complete='fg=747369,bg=none'
        ble-face syntax_default='fg=253'            
        ble-face command_builtin='fg=144'           
        ble-face syntax_error='fg=1,bg=none'

        bleopt complete_auto_complete=1
        bleopt highlight_syntax=1
      '';
    };

    programs = {
      ripgrep.enable = true;
      direnv.enable = true;

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      eza = {
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

        bashrcExtra = ''
          export PROMPT_DIRTRIM=2
          PS1='\[\033[0;32m\]\u@\h\[\033[0m\]: \[\033[0;34m\]\w\[\033[0m\]\[\033[0;33m\] $(git branch --show-current 2>/dev/null)\[\033[0m\]\$ '
        '';

        initExtra = ''
          source "$(blesh-share)"/ble.sh
          eval "$(direnv hook bash)"
          eval "$(zoxide init bash --cmd cd)"
        '';
      };
    };
  };
}
