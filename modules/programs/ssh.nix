{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.ssh;
in
{
  options.modules.programs.ssh.enable = mkEnableOption "Enable and configure ssh";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ cloudflared ];
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          SetEnv = {
            TERM = "xterm-256color";
          };
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
        "*.canonical.is" = {
          ProxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh -hostname %h";
        };
        lighthouse.HostName = "100.100.0.1";
        jumphost.HostName = "100.100.0.10";
        printer.HostName = "100.100.0.8";
        server.HostName = "100.100.0.2";
        desktop.HostName = "100.100.0.3";
        laptop.HostName = "100.100.0.4";
        feclaw = {
          User = "feclaw";
          HostName = "mytheory.net";
          Port = 8889;
        };
      };
    };
  };
}
