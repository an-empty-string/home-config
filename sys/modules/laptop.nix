{ pkgs, ... }: {
  imports = [
    ./common.nix
    ./graphical.nix
    ./efiBoot.nix
    ./keyd.nix
  ];

  # Networking: use NetworkManager instead of built-in DHCP units
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Firmware update services
  services.fwupd.enable = true;

  # Android
  programs.adb.enable = true;

  # Power management
  services.logind.settings.Login = {
    HibernateDelaySec = 1800;
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend-then-hibernate";
  };

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

  security.doas.extraRules = [{
    users = [ "tris" ];
    noPass = true;
    cmd = "/run/current-system/sw/bin/cpupower";
  }];

  # Audio and Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Other useful tools
  environment.systemPackages = with pkgs; [
    swaylock
    powertop
    tpm2-tools
  ];

  # Container management
  #virtualisation.docker.rootless.enable = true;
  virtualisation.docker.enable = true;

  # TPM support
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    pkcs11.package = pkgs.tpm2-pkcs11.overrideAttrs (f: p: {
      configureFlags = [ "--disable-fapi" ];
      # patches = p.patches ++ [
      #   ./0002-remove-fapi-message.patch
      # ];
    });
    abrmd.enable = true;
  };

  # PowerMate
  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_USB_DRIVER}=="powermate", SYMLINK+="input/powermate", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0161", MODE="0660", GROUP="input", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Noisetorch
  programs.noisetorch.enable = true;
}

