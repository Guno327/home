{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.gpg;
  pinentry = pkgs.writeScript "pinentry-auto" ''
    #!/usr/bin/env fish

    # Determine the base pinentry program
    set pe ${pkgs.pinentry-gnome3}

    # Select the appropriate pinentry based on PINENTRY_USER_DATA
    switch "$PINENTRY_USER_DATA"
        case "*USE_TTY*"
            set pe ${pkgs.pinentry-tty}/bin/pinentry-tty
        case "*USE_CURSES*"
            set pe ${pkgs.pinentry-curses}/bin/pinentry-curses
        case "*USE_GTK2*"
            set pe ${pkgs.pinentry-gtk2}/bin/pinentry-gtk2
        case "*USE_GNOME3*"
            set pe ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3
        case "*USE_QT*"
            set pe ${pkgs.pinentry-qt}/bin/pinentry-qt
        case "*"
            set pe ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3
    end

    # Execute the selected pinentry with all arguments
    exec $pe $argv

  '';
in {
  options.modules.services.gpg.enable = mkEnableOption "enable extended gpg configuration";
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };
    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      enableSshSupport = true;
      pinentry.package = pinentry;
    };
  };
}
