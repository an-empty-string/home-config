{ config, pkgs, ... }:

{
  imports = [
    ../modules/nfs.nix
    ../modules/tailscale.nix
  ];

  # Nix/nixpkgs configuration
  nix.package = pkgs.nixUnstable;
  nixpkgs.overlays = [ (import ../../overlay) ];
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.substituters = [
    # "http://deepslate.sparrow-frog.ts.net:5000"
    "https://cache.nixos.org/"
  ];

  # nix.settings.trusted-public-keys = [
  #   "deepslate.sparrow-frog.ts.net:yTKzIf66q7SNXvr+EQXA/TFODCBlj00cYxC25+rCIAw="
  # ];

  # Tailscale / remote access
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
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
  programs.zsh.enable = true;

  users.users.tris = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" "video" "input" "docker" "gemini" "www" "libvirtd" "adbusers" "plugdev" "keyd" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # YubiKey
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXEShUcOG0aNtI8+ZydcGJY7VPS6P35BohbM68cHyvvwK7+PKlPcloTfidHOaTTveD/5vMB9jKAuuY6uKAWJM5a6CNdS77+9ugeaCFDLc7I82eY+STXX8UehUi78LB0s3qOULvYpGvZIwG7Oz8L2O58ZJkeUgv+3r675m7ejaNOK15OeHL51xkZ/fn6C5T6EqkHxwjgWYUZTqRCLGb4nynnjcnMIzh0croSatEr8vmKa6eGwfbaEnLMJ4E7QY+JYD/H4X0QjmDqFUhTxeZ2gyvR5GOTVVuMe1047LcU/qv65zNDc96raPAGeNeC1h2c3e4rgUtl8KNuDo99aovItreJv6CuLBAgC5ZAsgwDl6qH03ahhVAyr7kdR0/4lTXYyOFnkKgnXcLu3GQtfb71rhTef+RbDKyMTcw2gOaTcn44hDJGGOWKce+a91CTIRlBEYj5/baiwesg5XP5loKjAqnP1smXnLLHvJBZawHU6qaS86PxxH1E26xGcYW1mdliS1O7U6odfkvPWZNumPFLP+nDUElsUTySrE0w0AOWLGRD8guGdhUh34RpTjcbnVSzfILciKIrEnYIThHJz1/AosUoVw3vPsO5/HFdz6VDHjZEoRzqG6RWLBa6lMtUE218c0HNMK8nuwPCciXOibnGzKYIKxIUCQs9sPtYpaJQMFZtQ=="
    ];
  };

  users.users.alyssa = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgpVY7X8AL0oHJaZIFy9Lfp9KaNsVqVi7e+X+CIAWd6"
    ];
  };

  users.users.hunter = {
    uid = 3199;
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBG8RmADAb6jH4agL6YUn0PiDVRJhKWds1P433m0N//8ExPsgdw02eJz40HVJtTOsUhXOA+3/6I0PC91wmbDUCkq+32cD8qYQQxXzAhqHgKsGECqvmfufn30Y2zrLR3loQMDtTojrgHExS33rO6/GnpLSUaQZ3XTmXzXaXryJDlPAeEpboabTQs29JnEvfK5Xv5grpKLHthJ4xw/hPqNSPqS3zQWdGdl71TSfopmNM1Wg0RAhgP4mHgfbPqXFpvnKtCpYfVSao49QDJck5D+KHNhFrkegVFHSSJ9rdjksUUP0ZBlQPlQeQsjLCLx7EWjgJ6gU23maDaJ6Ra82CSVxH hf0002@ppppowerbook"
    ];
  };

  users.groups.keyd = {};

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
    ncdu
    hid-tools
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
