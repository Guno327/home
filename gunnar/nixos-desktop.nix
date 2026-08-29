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
    rusty-path-of-building
    orca-slicer
    mattermost-desktop
    chromium
    xclicker
    code-cursor
    onlyoffice-desktopeditors
    remmina
    gimp
    homeInputs.custom-pkgs.packages."${stdenv.hostPlatform.system}".btd700ctl
    btop
    openconnect
    nebula
    (pkgs.symlinkJoin {
      name = "moonlight-qt-xwayland";
      paths = [ pkgs.moonlight-qt ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/moonlight \
          --set QT_QPA_PLATFORM xcb \
          --set SDL_VIDEODRIVER x11
      '';
    })
  ];

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      mpv.enable = true;
      ghostty.enable = true;
      minecraft.enable = true;
      virt-manager.enable = true;
      spotify.enable = true;
      zen.enable = true;
      poetrade.enable = true;
      nettools.enable = true;
      openscad.enable = true;
    };

    services = {
      gpg.enable = true;
      jellyfin-shim.enable = true;
    };

    wms = {
      sway = {
        enable = true;
        primaryDisplay = "DP-1";
        secondaryDisplay = "HDMI-A-1";
        term = "ghostty";
        startup = "${toString startupScript} > /home/gunnar/.scripts/startup.log";
      };
    };
  };
}
