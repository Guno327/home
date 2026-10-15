{
  config,
  lib,
  pkgs,
  homeInputs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.moonlight;
  sdl2File = "${homeInputs.nixpkgs-sdl2}/pkgs/development/libraries/SDL2/default.nix";
  sdl2Args = lib.functionArgs (import sdl2File);
  missing = lib.filterAttrs (n: hasDefault: !hasDefault && !(pkgs ? ${n})) sdl2Args;
  sdl2 =
    (pkgs.callPackage sdl2File (lib.mapAttrs (n: _: pkgs.${lib.toLower n} or null) missing))
    .overrideAttrs
      (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.libxcb
          pkgs.libgbm
          pkgs.libdrm
        ];
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE =
            toString (old.env.NIX_CFLAGS_COMPILE or "") + " -Wno-error=incompatible-pointer-types";
        };
      });
in
{
  options.modules.programs.moonlight.enable =
    mkEnableOption "enable extended moonlight configuration";
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.moonlight-qt.override {
        SDL2 = sdl2;
        SDL2_ttf = pkgs.SDL2_ttf.override { SDL2 = sdl2; };
      })
    ];
  };
}
