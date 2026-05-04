{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = lib.mkDefault "gunnar.hovik@canonical.com";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    packages = [ inputs.nvim-flake.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;

  gtk.gtk4.theme = lib.mkDefault null;

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      sizes = {
        applications = 12;
        desktop = 12;
        terminal = 14;
        popups = 12;
      };
    };
  };
}
