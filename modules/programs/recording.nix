{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.recording;
in
{
  options.modules.programs.recording.enable =
    mkEnableOption "Enable software for recording and editings";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.kdenlive
      (python3.withPackages (
        python-pkgs: with python-pkgs; [
          pip
          openai-whisper
          srt
          torch
        ]
      ))
    ];

    programs.obs-studio = {
      enable = true;
      plugins = [ ];
    };
  };
}
