{ stdenv
, fetchFromGitHub
, linuxHeaders ? stdenv.cc.libc.linuxHeaders }:

stdenv.mkDerivation {
  pname = "keyd";
  version = "v2.4.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = pname;
    rev = version;
    hash = "sha256-QWr+xog16MmybhQlEWbskYa/dypb9Ld54MOdobTbyMo=";
  };

  nativeBuildInputs = [ linuxHeaders ];

  meta = with lib; {
    description = "Key remapping daemon for Linux";
    homepage = "https://github.com/rvaiya/keyd";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ an-empty-string ];
  };
}
