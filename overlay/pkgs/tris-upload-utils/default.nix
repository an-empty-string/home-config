{ pkgs
, libnotify
, maim
, openssh
, xclip
, destinationBasePath ? "tris@tris.fyi:/var/www/f/"
, destinationBaseDownloadURL ? "https://f.tris.fyi/" }:

pkgs.writeShellScriptBin "upload-helper" ''
  set -e
  mkdir -p ~/uploaded

  stamp=$(date +%Y%m%d%H%M%S)

  if [ "$1" = "screenshot" ]; then
    filename="$stamp.png"
    ${maim}/bin/maim -s ~/uploaded/$filename
  elif [ "$1" = "pastebin" ]; then
    filename="$stamp.txt"
    ${xclip}/bin/xclip -selection clipboard -out > ~/uploaded/$filename
  else
    echo "Usage: $0 [screenshot|pastebin]"
    exit 2
  fi

  ${openssh}/bin/scp ~/uploaded/$filename ${destinationBasePath}$filename

  downloadURL="${destinationBaseDownloadURL}$filename"
  echo -n "$downloadURL" | ${xclip}/bin/xclip -selection clipboard -in

  ${libnotify}/bin/notify-send "Upload complete" "$downloadURL"
''
