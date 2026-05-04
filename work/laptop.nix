{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./home.nix
    ../common
    ../modules
  ];

  home.packages = with pkgs; [
    mattermost-desktop
  ];

  modules = {
    programs = {
      bash.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      ghostty.enable = true;
      spotify.enable = true;
      zen.enable = true;
      mpv.enable = true;
      nettools.enable = true;
    };

    services = {
      gpg.enable = true;
    };
  };
}
