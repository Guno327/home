{
  description = "Home Manager configuration of gunnar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    custom-pkgs = {
      url = "github:guno327/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    sops-nix,
    zen-browser,
    stylix,
    custom-pkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      # NixOS configurations
      "gunnar@nixos-desktop" = home-manager.lib.homemanagerconfiguration {
        inherit pkgs;
        extraspecialargs = {inherit inputs;};
        modules = [
        ];
      };
      "gunnar@nixos-laptop" = home-manager.lib.homemanagerconfiguration {
        inherit pkgs;
        extraspecialargs = {inherit inputs;};
        modules = [
        ];
      };
      "gunnar@nixos-server" = home-manager.lib.homemanagerconfiguration {
        inherit pkgs;
        extraspecialargs = {inherit inputs;};
        modules = [
        ];
      };

      # Generic Linux configurations
      "gunnar@ubuntu-desktop" = home-manager.lib.homemanagerconfiguration {
        inherit pkgs;
        extraspecialargs = {inherit inputs;};
        modules = [
        ];
      };
      "gunnar@work-laptop" = home-manager.lib.homemanagerconfiguration {
        inherit pkgs;
        extraspecialargs = {inherit inputs;};
        modules = [
        ];
      };
    };
  };
}
