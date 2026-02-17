{
  pkgs,
  lib,
  ...
}: let
  startupScript = pkgs.writeScript "startup" ''
    #!/usr/bin/env bash
  '';
in {
  imports = [
    ./home.nix
    ../common
    ../modules
  ];

  home.packages = with pkgs; [
    discord
  ];

  modules = {
    programs = {
      fish.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      eza.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      devenv.enable = true;
      alacritty.enable = true;
      minecraft.enable = true;
      spotify.enable = true;
      firefox.enable = true;
      mpv.enable = true;
    };

    services = {
      gpg.enable = true;
    };

    wms = {
      sway = {
        enable = true;
        primaryDisplay = "eDP-1";
        term = "alacritty";
        startup = "${toString startupScript} > /home/gunnar/.scripts/startup.log";
      };
    };

    programs.alacritty.settings.font.size = lib.mkForce 12;
  };
}
