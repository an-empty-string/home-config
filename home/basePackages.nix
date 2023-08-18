{ pkgs, unstable, ... }: 

{
  home.packages = (with pkgs; [
    # glauth
    acpi
    asciinema
    awscli2
    backblaze-b2
    bind
    binutils
    binwalk
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
    keyd
    lftp
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
    rclone
    redis
    rmapi
    ruby
    rustup
    semgrep
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
    wget
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
      lxml
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
      websocket-client

      shapely

      tris-config
    ]))
  ]) ++ (with unstable; [
    cloudflared
  ]);
}
