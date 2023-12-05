{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "bottom";

        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-right = [ "custom/keyd" "custom/pomodoro" "custom/ifconfig" "battery" "clock" "tray" ];

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 10;
          };

          format-time = "{H}h{M}m";
          format-discharging = "{capacity}%- {time}";
          format-charging = "{capacity}%+ {time}";

          format = "{capacity}%";
        };

        "custom/ifconfig" = {
          exec = ''
            ${pkgs.curl}/bin/curl --connect-timeout 1 -s https://wtfismyip.com/text || echo disconnected;
          '';
          on-click = "${pkgs.coreutils}/bin/true";
          interval = 120;
        };

        "custom/keyd" = {
          exec = "${pkgs.mosquitto}/bin/mosquitto_sub -t keyd-layers";
        };

        "custom/pomodoro" = {
          exec = "${pkgs.mosquitto}/bin/mosquitto_sub -t pomodoro/statusline";
          on-click = "${pkgs.mosquitto}/bin/mosquitto_pub -t pomodoro/command -m trigger";
          on-click-right = "${pkgs.mosquitto}/bin/mosquitto_pub -t pomodoro/command -m reset";
        };
      };
    };

    style = ''
      * {
        font-family: Comic Mono;
        font-size: 13pt;
      }

      window#waybar {
        background-color: #262626;
      }

      #workspaces button {
        background: #262626;
        border: #262626;
        padding: 0 5px;
        color: inherit;
        border-radius: 0;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        background: #363636;
        border: #363636;
        padding: 0 5px;
      }

      #workspaces button:not(.focused) {
        color: #ebdbb2;
      }

      #workspaces button.focused {
        background-color: #d3869b;
        color: #262626;
      }

      #window {
        margin-left: 0.5em;
        color: #ebdbb2;
      }

      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      #custom-keyd,
      #custom-pomodoro,
      #custom-ifconfig,
      #battery,
      #clock,
      #tray
      {
          padding: 0 10px;
          color: #ebdbb2;
      }

      #clock {
        color: #262626;
        background-color: #83a598;
      }

      #battery {
        color: #262626;
        background-color: #b8bb26;
      }

      #battery.warning {
        background-color: #fabd2f;
      }

      #battery.critical {
        background-color: #fb4934;
      }

      #custom-ifconfig {
        color: #262626;
        background-color: #ebdbb2;
      }

      #custom-pomodoro {
        color: #262626;
        background-color: #fabd2f;
      }

      #custom-keyd {
        color: #262626;
        background-color: #d3869b;
      }

      #tray {
        border: 1px solid #665c54;
        margin-left: 1px;
      }
    '';

    systemd.enable = true;
  };
}
