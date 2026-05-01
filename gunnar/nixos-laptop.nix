{
  pkgs,
  lib,
  ...
}:
let
  startupScript = pkgs.writeScript "startup" ''
    #!/usr/bin/env bash
  '';
in
{
  imports = [
    ./home.nix
    ../common
    ../modules
  ];

  home.packages = with pkgs; [
    discord
    moonlight-qt
    remmina
  ];

  modules = {
    programs = {
      bash.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      ghostty.enable = true;
      minecraft.enable = true;
      spotify.enable = true;
      zen.enable = true;
      mpv.enable = true;
      nettools.enable = true;
    };

    services = {
      gpg.enable = true;
    };

    wms = {
      sway = {
        enable = true;
        primaryDisplay = "eDP-1";
        term = "ghostty";
        startup = "${toString startupScript} > /home/gunnar/.scripts/startup.log";
      };
    };
  };
}
