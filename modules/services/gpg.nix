{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg.enable = mkEnableOption "enable extended gpg configuration";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pinentry-gtk2
    ];

    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      settings = {
        pinentry-mode = "loopback";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-tty;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };

    programs.ssh.matchBlocks."*".match = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
  };
}
