{ pkgs, unstable, ... }: 

{
  home.packages = (with pkgs; [
    glauth
    acpi
    asciinema
    awscli2
    bind
    binutils
    binwalk
    catgirl
    direnv
    dos2unix
    ffmpeg
    file
    fzf
    gcc
    gnumake
    htop
    inetutils
    jdk
    jq
    mariadb-client
    mosh
    mosquitto
    nmap
    nodejs
    openssl
    pandoc
    picocom
    poppler_utils
    pre-commit
    pv
    pwgen
    qsynth
    redis
    rmapi
    ruby
    rustup
    silver-searcher
    sipcalc
    sshfs
    sshpass
    sshuttle
    step-cli
    sqlite-interactive
    unzip
    visidata
    weechat
    zip

    consul
    vault
    nomad

    (python310.withPackages (p: with p; [
      arrow
      asyncio-mqtt
      black
      click
      cryptography
      flake8
      flask
      httpx
      ipython
      mido
      mypy
      poetry
      pygame
      pytest
      pyyaml
      redis
      requests
      rich
      tox

      tris-config
    ]))
  ]) ++ (with unstable; [
    cloudflared
  ]);
}
