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
      loginShellInit = ''
        if set -q SSH_CLIENT || set -q SSH_TTY
          set -x PINENTRY_USER_DATA "USE_CURSES"
        else
          set -x PINENTRY_USER_DATA "USE_GNOME2"
        end

        set -x NIX_PATH nixpkgs=channel:nixos-unstable
        set -x NIX_LOG info
        direnv hook fish | source
      '';
    };
  };
}
