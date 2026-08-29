{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zen;
in
{
  options.modules.programs.zen.enable = mkEnableOption "Install and configure zen";

  config = mkIf cfg.enable {
    stylix.targets.zen-browser.profileNames = [ "Gunnar" ];
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];

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
            {
              Name = "SearXNG";
              IconURL = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/searxng.svg";
              URLTemplate = "https://search.ghov.net/search?q={searchTerms}&category_general=on&language=auto&time_range=&safesearch=0&theme=simple";
              Method = "GET";
            }
          ];
          Default = "SearXNG";
        };
      };
    };
  };
}
