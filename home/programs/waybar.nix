{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "bottom";

        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-right = [ "custom/keyd" "battery" "clock" "tray" ];

        clock = {
          format = "{:%a %Y-%m-%d %H:%M}";
          tooltip-format = "{calendar}";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
          };
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
        background-color: #eeeeee;
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
      #custom-co2,
      #battery,
      #clock,
      #tray
      {
          padding: 0 10px;
          color: #ebdbb2;
      }

      #clock {
        color: #262626;
        background-color: #eeeeee;
      }

      #battery {
        color: #262626;
        background-color: #dddddd;
      }

      #battery.warning {
        background-color: #cccccc;
      }

      #battery.critical {
        background-color: #000000;
        color: #ffffff;
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
