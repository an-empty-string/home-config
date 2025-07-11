{ pkgs, unstable, ... }: 

{
  home.packages = (with pkgs; [
    acpi
    act
    age
    alsa-utils
    asciinema
    awscli2
    backblaze-b2
    bind
    binutils
    binwalk
    cmake
    delta
    diffoscope
    direnv
    dos2unix
    exiftool
    ffmpeg
    file
    fzf
    gcc
    gdal
    geos
    gnumake
    google-cloud-sdk
    graphqurl
    html-tidy
    htop
    imagemagick
    inetutils
    iperf3
    jdk
    jq
    unstable.keyd
    lftp
    mariadb-client
    meson
    mosh
    mosquitto
    ninja
    nmap
    nodejs
    openssl
    pandoc
    parallel
    pat
    picocom
    pkg-config
    postgresql
    poppler_utils
    pre-commit
    progress
    pv
    pwgen
    pyright
    rclone
    redis
    rmapi
    ruby
    silver-searcher
    sipcalc
    soupault
    sshfs
    sshpass
    sshuttle
    step-cli
    sqlite-interactive
    unzip
    unstable.visidata
    weechat
    wget
    xmlstarlet
    zip

    nomad
    packer
    rain

    (python312.withPackages (p: with p; [
      aiomqtt
      arrow
      awacs
      black
      boto3
      boto3-stubs
      click
      cryptography
      flake8
      flask
      httpx
      ipython
      lxml
      mysqlclient
      psycopg2
      pygame
      pyserial
      pytest
      pyyaml
      redis
      requests
      rich
      tox
      troposphere
      websockets

      pyproj
      shapely

      tris-config
    ]))
  ]) ++ (with unstable; [
    cloudflared
  ]);
}
