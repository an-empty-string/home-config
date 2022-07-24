{ pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    acpi
    asciinema
    awscli2
    bind
    binutils
    binwalk
    cloudflared
    direnv
    dos2unix
    ffmpeg
    fzf
    gcc
    gnumake
    htop
    inetutils
    jdk
    jq
    mosh
    mosquitto
    nmap
    nodejs
    openssl
    pandoc
    picocom
    pv
    pwgen
    rmapi
    ruby
    rustup
    silver-searcher
    sipcalc
    sshfs
    sshpass
    step-cli
    unzip
    visidata
    zip

    (python39.withPackages (p: with p; [
      arrow
      black
      cryptography
      flake8
      flask
      httpx
      ipython
      mypy
      pygame
      pytest
      requests
    ]))
  ];
}
