{ pkgs, unstable, ... }: with pkgs; [
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
  htop
  inetutils
  jdk
  jq
  mosh
  mosquitto
  nmap
  nodejs
  openssl
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
    ipython
    mypy
    pygame
    pytest
    requests
  ]))
]
