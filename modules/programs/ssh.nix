{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.ssh;
in {
  options.modules.programs.ssh.enable = mkEnableOption "Enable and configure ssh";
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        vps = {
          host = "vps";
          hostname = "100.100.0.1";
        };
        server = {
          host = "server";
          hostname = "100.100.0.2";
        };
        desktop = {
          host = "desktop";
          hostname = "100.100.0.3";
        };
        laptop = {
          host = "laptop";
          hostname = "100.100.0.4";
        };
      };
    };
  };
}
