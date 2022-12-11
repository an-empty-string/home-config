{ config, pkgs, ... }:

{
  imports = [
    ../modules/nfs.nix
    ../modules/tailscale.nix
  ];

  # Nix/nixpkgs configuration
  nix.package = pkgs.nixUnstable;
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Tailscale / remote access
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  services.openssh = {
    enable = true;
    openFirewall = false;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # Language, console, keyboard layout setup
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Users
  users.users.tris = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" "video" "input" "docker" "gemini" "www" "libvirtd" "adbusers" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # YubiKey
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXEShUcOG0aNtI8+ZydcGJY7VPS6P35BohbM68cHyvvwK7+PKlPcloTfidHOaTTveD/5vMB9jKAuuY6uKAWJM5a6CNdS77+9ugeaCFDLc7I82eY+STXX8UehUi78LB0s3qOULvYpGvZIwG7Oz8L2O58ZJkeUgv+3r675m7ejaNOK15OeHL51xkZ/fn6C5T6EqkHxwjgWYUZTqRCLGb4nynnjcnMIzh0croSatEr8vmKa6eGwfbaEnLMJ4E7QY+JYD/H4X0QjmDqFUhTxeZ2gyvR5GOTVVuMe1047LcU/qv65zNDc96raPAGeNeC1h2c3e4rgUtl8KNuDo99aovItreJv6CuLBAgC5ZAsgwDl6qH03ahhVAyr7kdR0/4lTXYyOFnkKgnXcLu3GQtfb71rhTef+RbDKyMTcw2gOaTcn44hDJGGOWKce+a91CTIRlBEYj5/baiwesg5XP5loKjAqnP1smXnLLHvJBZawHU6qaS86PxxH1E26xGcYW1mdliS1O7U6odfkvPWZNumPFLP+nDUElsUTySrE0w0AOWLGRD8guGdhUh34RpTjcbnVSzfILciKIrEnYIThHJz1/AosUoVw3vPsO5/HFdz6VDHjZEoRzqG6RWLBa6lMtUE218c0HNMK8nuwPCciXOibnGzKYIKxIUCQs9sPtYpaJQMFZtQ=="

      # dripleaf TPM
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLQkbAMhZuf7qXNrqx61sNU/34RdBamkePfkbK39x6tR3FRkfdsrc5ySgXYoObbNeJSDYRbPwUd/IXuOdvPQPtk="
    ];
  };

  # Kernel firmware
  hardware.enableAllFirmware = true;

  # Hardening
  boot.kernel.sysctl."kernel.unprivileged_bpf_disabled" = 1;

  security.sudo.enable = false;
  security.doas.enable = true;

  # RTL-SDR support
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];

  # Other useful tools
  environment.systemPackages = with pkgs; [
    git
    home-manager
    pciutils
    tailscale
    usbutils
    vim
    tcpdump
  ];

  programs.mtr.enable = true;

  # Local MQTT server
  # Firewall will limit this to Tailscale and local access only
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
        acl = [ "pattern readwrite #" ];
      }
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];
}
