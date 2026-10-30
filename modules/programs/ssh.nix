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
        server.HostName = "100.100.0.3";
        desktop.HostName = "100.100.0.4";
        game-server.HostName = "100.100.0.5";
        laptop.HostName = "100.100.0.6";
        phone.HostName = "100.100.0.7";
        printer.HostName = "100.100.0.8";
        jumphost-1.HostName = "100.100.0.101";
        jumphost-2.HostName = "100.100.0.102";
        jumphost-3.HostName = "100.100.0.103";
        feclaw = {
          User = "feclaw";
          HostName = "mytheory.net";
          Port = 8889;
        };
      };
    };
  };
}
