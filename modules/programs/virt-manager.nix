{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.virt-manager;
in
{
  options.modules.programs.virt-manager.enable =
    mkEnableOption "Config for virt-manager, must enable in configuration.nix";

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
