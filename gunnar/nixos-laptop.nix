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
    moonlight-qt
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
        term = "ghostty";
        startup = "${toString startupScript} > /home/gunnar/.scripts/startup.log";
        workspaceFallback = [ "eDP-1" ];
        displays = {
          "eDP-1" = {
            mode = "1920x1080@240.001Hz";
            adaptiveSync = true;
            bar = "full";
          };
          "Dell Inc. DELL S2721DGF 3DRTP83" = {
            mode = "2560x1440@143.912Hz";
            position = "1080 220";
            adaptiveSync = true;
            workspaces = [
              "1"
              "2"
              "3"
              "4"
              "5"
            ];
            bar = "full";
          };
          "NEC Corporation E243WMi 44107212NA" = {
            mode = "1920x1080@60.000Hz";
            position = "0 0";
            transform = "90";
            workspaces = [
              "6"
              "7"
              "8"
              "9"
              "0"
            ];
            bar = "minimal";
          };

        };
      };
    };
  };

  wayland.windowManager.sway.extraConfig = ''
    bindswitch --reload --locked lid:on output eDP-1 disable
    bindswitch --reload --locked lid:off output eDP-1 enable
  '';
}
