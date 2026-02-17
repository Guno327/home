{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.jellyfin-shim;
in {
  options.modules.services.jellyfin-shim.enable = mkEnableOption "enable jellyfin-mpv-shim configuration";
  config = mkIf cfg.enable {
    # Need mpv
    config.options.modules.programs.mpv.enable = mkForce true;

    home.packages = with pkgs; [jellyfin-mpv-shim];
    services.jellyfin-mpv-shim = {
      enable = true;
      settings = {
        fullscreen = false;
        mpv_ext = true;
        mpv_ext_path = "/etc/profiles/per-user/${config.home.username}/bin/mpv";
        mpv_ext_no_ovr = false;
      };
    };
  };
}
