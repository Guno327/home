{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
}
