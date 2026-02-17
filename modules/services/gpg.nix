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
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };
    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
