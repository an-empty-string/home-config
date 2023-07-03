{ pkgs, unstable, ... }: 

{
  home.packages = (with pkgs; [
    # glauth
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
    gdal
    geos
    gnumake
    htop
    inetutils
    iperf3
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
    postgresql
    poppler_utils
    pre-commit
    progress
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
    packer

    (python310.withPackages (p: with p; [
      arrow
      asyncio-mqtt
      black
      boto3
      click
      cryptography
      flake8
      flask
      httpx
      ipython
      mido
      mypy
      mysqlclient
      # poetry
      pygame
      pytest
      pyyaml
      redis
      requests
      rich
      tox

      shapely

      tris-config
    ]))
  ]) ++ (with unstable; [
    cloudflared
  ]);
}
