{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.programs.nettools;
in
with lib;
{
  options.modules.programs.nettools.enable = mkEnableOption "enable network diag tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      netcat
      arp-scan
      wireshark
      nmap
      tcpdump
      traceroute
      dig
      lsof
      curl
      wget
    ];
  };

}
