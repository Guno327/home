{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.wms.sway;

  displayOpts =
    { name, ... }:
    {
      options = {
        mode = mkOption {
          type = types.nullOr types.str;
          description = "Output mode, e.g. 2560x1440@144Hz";
          default = null;
        };
        position = mkOption {
          type = types.nullOr types.str;
          description = "Output position, e.g. \"0 0\"";
          default = null;
        };
        transform = mkOption {
          type = types.nullOr types.str;
          description = "Output transform, e.g. \"90\"";
          default = null;
        };
        scale = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        adaptiveSync = mkOption {
          type = types.bool;
          default = false;
        };
        extra = mkOption {
          type = types.attrsOf types.str;
          description = "Extra raw sway output settings";
          default = { };
        };
        workspaces = mkOption {
          type = types.listOf types.str;
          description = "Workspaces assigned to this display";
          default = [ ];
        };
        bar = mkOption {
          type = types.enum [
            "full"
            "minimal"
            "none"
          ];
          description = "Which waybar to show on this display";
          default = "none";
        };
      };
    };

  displaysWithBar = bar: attrNames (filterAttrs (_: d: d.bar == bar) cfg.displays);

  # Common waybar module definitions shared by all bars
  waybarModules = {
    layer = "top";
    position = "bottom";
    mod = "dock";
    exclusive = true;
    passthrough = false;
    gtk-layer-shell = true;
    height = 0;

    "sway/workspaces" = {
      all-outputs = false;
      format = "{index}";
      disable-scroll = true;
    };

    "custom/weather" = {
      format = "{}°F";
      tooltip = true;
      interval = 3600;
      exec = "wttrbar --fahrenheit";
      return-type = "json";
    };

    "custom/sep" = {
      format = " | ";
    };

    tray = {
      icon-size = 13;
      spacing = 10;
    };

    clock = {
      format = " {:%R   %m/%d/%y} ";
      tooltip-format = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
    };

    pulseaudio = {
      format = " {icon}{volume} ";
      format-muted = "󰝟 ";
      format-icons = {
        default = " ";
        headphone = "󰋋";
      };
    };

    backlight = {
      format = "󰖨 {percent} ";
    };

    battery = {
      format = "{icon}{capacity} ";
      interval = 10;
      states = {
        critical = 10;
        warning = 30;
        normal = 50;
        high = 80;
        full = 95;
      };
      format-plugged = "{capacity} ";
      format-charging = "󱐋{capacity} ";
      format-icons = [
        " "
        " "
        " "
        " "
        " "
      ];
    };

    network = {
      format-wifi = " {essid} ";
      format-ethernet = "󰈀 {ipaddr} ";
    };

    mpris = {
      format = "{player_icon} {title} - {artist} ({position}/{length}) ";
      format-paused = "{player_icon} {status} ";
      player-icons = {
        default = "▶";
        mpv = "🎵";
        spotifyd = " ";
      };
      status-icons = {
        paused = "⏸";
      };
      ignored-players = [
        "firefox"
        "librewolf"
        "brave"
      ];
    };

    cpu = {
      format = " {usage}% ";
    };

    memory = {
      format = " {percentage}% ";
    };

    "custom/mic" = {
      exec = ''pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes && echo '{"text":"󰍭","class":"muted"}' || echo '{"text":"󰍬","class":"live"}' '';
      return-type = "json";
      interval = 1;
      on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      tooltip = false;
    };
  };
in
{
  options.modules.wms.sway = {
    enable = mkEnableOption "enable and configure sway";
    displays = mkOption {
      type = types.attrsOf (types.submodule displayOpts);
      description = ''
        Displays keyed by identifier — either a connector name (eDP-1) or
        the "Make Model Serial" string from `swaymsg -t get_outputs`.
      '';
      default = { };
    };
    workspaceFallback = mkOption {
      type = types.listOf types.str;
      description = "Display identifiers to fall back to when a workspace's display is absent, in priority order";
      default = [ ];
    };
    term = mkOption {
      type = types.str;
      description = "Default Terminal";
      default = "xterm";
    };
    startup = mkOption {
      type = types.path;
      description = "Startup Script";
    };
    wallpaper = mkOption {
      type = types.path;
      description = "Path to wallpaper svg";
      default = "/flake/home/modules/wms/bg.svg";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      librsvg
      wl-clipboard
      grim
      slurp
      swaylock-effects
      swaynotificationcenter
      wttrbar
      wofi
      playerctl
      swaybg
      mako
      sway-scratch
      polkit
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config.common.default = "wlr";
    };

    services = {
      gnome-keyring.enable = true;
    };

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      systemd.variables = [ "--all" ];
      config = {
        modifier = "Mod4";
        terminal = cfg.term;
        bars = [ ];

        output = mapAttrs (
          _: d:
          filterAttrs (_: v: v != null) {
            mode = d.mode;
            pos = d.position;
            transform = d.transform;
            scale = d.scale;
            adaptive_sync = if d.adaptiveSync then "on" else null;
          }
          // d.extra
        ) cfg.displays;

        workspaceOutputAssign = concatLists (
          mapAttrsToList (
            name: d:
            map (ws: {
              workspace = ws;
              output = [ name ] ++ (filter (f: f != name) cfg.workspaceFallback);
            }) d.workspaces
          ) cfg.displays
        );

        startup = [
          { command = "waybar"; }
          { command = "swaync"; }
          { command = "swaybg -m center -i ${cfg.wallpaper}"; }
          { command = cfg.startup; }
        ];

        assigns = {
          "2" = [
            { app_id = "firefox"; }
            { app_id = "zen"; }
          ];
          "3" = [ { app_id = "steam"; } ];
          "6" = [
            { app_id = "discord"; }
            { app_id = "WebCord"; }
          ];
        };

        window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "^.*";
            };
          }
        ];

        input = {
          "type:touchpad" = {
            "natural_scroll" = "enabled";
          };
        };

        keybindings =
          let
            mod = config.wayland.windowManager.sway.config.modifier;
          in
          mkOptionDefault {
            "${mod}+v" = "floating toggle";
            "${mod}+c" = "kill";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+Left" = "focus left";
            "${mod}+Right" = "focus right";
            "${mod}+Up" = "focus up";
            "${mod}+Down" = "focus down";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Control+Up" = "resize grow height 1 px or 1 ppt";
            "${mod}+Control+Down" = "resize shrink height 1 px or 1 ppt";
            "${mod}+Control+Left" = "resize grow width 1 px or 1 ppt";
            "${mod}+Control+Right" = "resize shrink width 1 px or 1 ppt";

            "XF86MonBrightnessDown" = "exec brightnessctl --quiet s 10%-";
            "XF86MonBrightnessUp" = "exec brightnessctl --quiet s +10%";
            "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioPause" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
            "Print" = "exec slurp | grim -g - - | wl-copy";

            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 0";
            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 0";

            "${mod}+r" = "reload";
            "${mod}+Shift+r" = "restart";

            "${mod}+d" = "exec wofi --show run";
            "${mod}+Shift+d" = "exec wofi --show drun";
            "${mod}+n" = "exec swaync-client -t -sw";
            "${mod}+Return" = "exec ${cfg.term}";
            "${mod}+m" =
              ''exec sh -c "pactl set-source-mute easyeffects_source toggle && pactl get-source-mute easyeffects_source | grep -q yes && notify-send 'Mic muted' || notify-send 'Mic unmuted'"'';
            "${mod}+l" = ''
              exec swaylock \
              --screenshots \
              --clock \
              --indicator \
              --indicator-radius 100 \
              --indicator-thickness 7 \
              --effect-blur 7x5 \
              --effect-vignette 0.5:0.5 \
              --fade-in 0.2
            '';
            "--locked ${mod}+Shift+s" = "exec systemctl suspend";
          };
      };
    };

    programs.waybar = {
      enable = true;
      settings =
        optionalAttrs (displaysWithBar "full" != [ ]) {
          full = waybarModules // {
            output = displaysWithBar "full";
            modules-left = [ "sway/workspaces" ];
            modules-center = [ "mpris" ];
            modules-right = [
              "custom/mic"
              "pulseaudio"
              "network"
              "cpu"
              "memory"
              "battery"
              "backlight"
              "clock"
              "tray"
            ];
          };
        }
        // optionalAttrs (displaysWithBar "minimal" != [ ]) {
          minimal = waybarModules // {
            output = displaysWithBar "minimal";
            modules-left = [ "sway/workspaces" ];
            modules-right = [ "clock" ];
          };
        };
    };
  };
}
