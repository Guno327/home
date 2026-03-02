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
        ble-face -s argument_error fg=#f38ba8
        ble-face -s argument_option fg=#f2cdcd
        ble-face -s auto_complete fg=#9399b2       
        ble-face -s command_builtin fg=#fab387
        ble-face -s command_alias fg=#b4befe
        ble-face -s command_directory fg=#89b4fa
        ble-face -s command_keyword fg=#cba6f7
        ble-face -s syntax_comment fg=#f9e2af
        ble-face -s syntax_error fg=#f38ba8
        ble-face -s syntax_varname fg=#f5e0dc
        ble-face -s region bg=#45475a

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
          "lxc" = "incus";
          "lxd" = "incus admin";
        };

        bashrcExtra = ''
          export PROMPT_DIRTRIM=2
          PS1='\[\033[0;32m\]\u@\h\[\033[0m\]: \[\033[0;34m\]\w\[\033[0m\]\[\033[0;33m\] $(git branch --show-current 2>/dev/null)\[\033[0m\]> '
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
