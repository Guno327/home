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

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    custom-pkgs = {
      url = "github:guno327/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf-flake = {
      url = "github:guno327/nvf-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    sops-nix,
    zen-browser,
    caelestia-shell,
    nvf-flake,
    stylix,
    custom-pkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS configurations
    homeModules = {
      nixos-desktop = {
        imports = [
          ./gunnar/nixos-desktop.nix
          zen-browser.homeModules.twilight
          caelestia-shell.homeManagerModules.default
        ];
        _module.args = {homeInputs = inputs;};
      };
      nixos-laptop = {
        imports = [
          ./gunnar/nixos-laptop.nix
          zen-browser.homeModules.twilight
          caelestia-shell.homeManagerModules.default
        ];
        _module.args = {homeInputs = inputs;};
      };
      nixos-server = {
        imports = [
          ./gunnar/nixos-server.nix
          zen-browser.homeModules.twilight
          caelestia-shell.homeManagerModules.default
        ];
        _module.args = {homeInputs = inputs;};
      };
    };

    # Generic Linux configurations
    homeConfigurations = {
      "gunnar@ubuntu-desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
        ];
      };
      "gunnar@work-laptop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./work/laptop.nix
          zen-browser.homeModules.twilight
          caelestia-shell.homeManagerModules.default
        ];
      };
    };
  };
}
