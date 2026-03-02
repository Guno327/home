{ ... }:
{
  imports = [
    ./home.nix
    ../common
    ../modules
  ];

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      nettools.enable = true;
    };

    services = {
      gpg.enable = true;
    };
  };
}
