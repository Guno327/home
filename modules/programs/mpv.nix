{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.mpv;
in {
  options.modules.programs.mpv.enable = mkEnableOption "enable extended mpv configuration";
  config = mkIf cfg.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        embed-chapters = true;
        embed-metadata = true;
        embed-thumbnail = true;
      };
    };

    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
        force-window = true;
        cache-default = 4000000;

        save-position-on-quit = true;
        resume-playback = true;
      };
      scripts = with pkgs.mpvScripts; [
        mpris
      ];
    };
  };
}
