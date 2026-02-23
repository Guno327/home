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
      fish.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      eza.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      devenv.enable = true;
      alacritty.enable = true;
      spotify.enable = true;
      zen.enable = true;
      mpv.enable = true;
      netools.enable = true;
    };

    services = {
      gpg.enable = true;
    };
  };
  programs.alacritty.settings.font.size = lib.mkForce 12;
}
