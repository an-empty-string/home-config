{ pkgs, ... }: {
  imports = [
    ./common.nix
    ./efiBoot.nix
  ];

  # Networking: use NetworkManager instead of built-in DHCP units
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Firmware update services
  services.fwupd.enable = true;

  # Keyboard
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];

  # Android
  programs.adb.enable = true;

  # Power management
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    HibernateDelaySec=1800
    HandlePowerKey=suspend
  '';

  boot.kernelModules = [ "intel_pstate" ];

  services.throttled.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      DISK_APM_LEVEL_ON_BAT = "1 1";
      INTEL_GPU_MAX_FREQ_ON_BAT = 350;

      # Battery charge thresholds are in system configurations
    };
  };

  # Graphical environment
  programs.sway.enable = true;

  services.xserver = {
    # N.B. - doesn't actually run an X server, just sets up graphics drivers
    # enough for us to use Wayland properly
    enable = true;
    videoDrivers = [ "modesetting" ];
    displayManager.startx.enable = true;
  };

  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.rofi-wayland}/bin/rofi -dmenu";
        };
      };
    };
  };

  # Steam
  programs.steam.enable = true;

  # Audio and Bluetooth
  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  # Other useful tools
  environment.systemPackages = with pkgs; [
    swaylock
    powertop
    tpm2-tools
  ];

  programs.wshowkeys.enable = true;

  # Container management
  virtualisation.docker.rootless.enable = true;

  # TPM support
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    pkcs11.package = pkgs.tpm2-pkcs11.overrideAttrs (f: p: {
      configureFlags = [ "--disable-fapi" ];
      patches = p.patches ++ [
        ./0002-remove-fapi-message.patch
      ];
    });
    abrmd.enable = true;
  };

  # AppVM
  virtualisation.appvm.enable = true;
  virtualisation.appvm.user = "tris";
}

