{ ... }: {
  enable = true;

  settings = {
    mainBar = {
      position = "bottom";

      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-right = [ "battery" "clock" "tray" ];

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

    .modules-left > widget:first-child > #workspaces {
      margin-left: 0;
    }

    #clock,
    #battery,
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

    #tray {
      border: 1px solid #665c54;
      margin-left: 1px;
    }
  '';

  systemd.enable = true;
}
