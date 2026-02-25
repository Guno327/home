{
  pkgs,
  homeInputs,
  ...
}:
let
  startupScript = pkgs.writeScript "startup.sh" ''
    #! /usr/bin/env bash
    discord &
    zen &
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
    r2modman
    homeInputs.custom-pkgs.packages."${stdenv.hostPlatform.system}".balatro-mobile-maker
    homeInputs.custom-pkgs.packages."${stdenv.hostPlatform.system}".balatro-multiplayer
    rusty-path-of-building
    orca-slicer
    gemini-cli
    mattermost-desktop
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
      mpv.enable = true;
      foot.enable = true;
      minecraft.enable = true;
      virt-manager.enable = true;
      spotify.enable = true;
      zen.enable = true;
      poetrade.enable = true;
      nettools.enable = true;
    };

    services = {
      gpg.enable = true;
      jellyfin-shim.enable = true;
    };

    wms = {
      sway = {
        enable = true;
        primaryDisplay = "DP-1";
        secondaryDisplay = "DP-2";
        term = "foot";
        startup = "${toString startupScript} > /home/gunnar/.scripts/startup.log";
      };
    };
  };
}
