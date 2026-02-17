{...}: {
  imports = [
    ./home.nix
    ../common
    ../modules
  ];

  modules = {
    programs = {
      fish.enable = true;
      ripgrep.enable = true;
      bat.enable = true;
      zoxide.enable = true;
      eza.enable = true;
      git.enable = true;
      fzf.enable = true;
      ssh.enable = true;
      devenv.enable = true;
    };

    services = {
      gpg.enable = true;
    };
  };
}
