{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.zen;
in {
  options.modules.programs.zen.enable = mkEnableOption "Install and configure zen";

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];

      policies = {
        FirefoxHome.Search = true;
        SearchEngines = {
          Add = [
            {
              Name = "Brave";
              IconURL = "https://brave.com/favicon.ico";
              URLTemplate = "https://search.brave.com/search?q={searchTerms}";
              Method = "GET";
            }
          ];
          Default = "Brave";
        };
      };
    };
  };
}
