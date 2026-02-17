{
  config,
  lib,
  ...
}: {
  home = {
    username = lib.mkDefault "gunnar.hovik@canonical.com";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
