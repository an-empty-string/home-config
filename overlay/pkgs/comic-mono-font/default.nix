{ lib, fetchFromGitHub }:

let
  version = "20201228";
in fetchFromGitHub {
  name = "comic-mono-font-${version}";

  owner = "dtinth";
  repo = "comic-mono-font";
  rev = "9a96d04cdd2919964169192e7d9de5012ef66de4";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar -z -f $downloadedFile --wildcards -x \*.ttf --one-top-level=$out/share/fonts

    mkdir -p $out/etc/fonts/conf.d
    cp ${./comic-mono-weight.conf} $out/etc/fonts/conf.d/30-comic-mono.conf
  '';

  hash = "sha256-aiKKUmc9M7gmqbIlktQT1HhPxB+CehGuj0mp56eGWmM=";

  meta = with lib; {
    description = "A legible monospace font that looks like Comic Sans";
    longDescription = ''
      A legible monospace font... the very typeface you’ve been trained to
      recognize since childhood. This font is a fork of Shannon Miwa’s Comic
      Shanns (version 1).
    '';
    homePage = "https://dtinth.github.io/comic-mono-font/";

    license = licenses.mit;
    maintainers = with maintainers; [ an-empty-string ];
    platforms = platforms.all;
  };
}
