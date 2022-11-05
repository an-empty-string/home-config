{ buildGoModule, fetchFromGitHub, lib, openldap }:

buildGoModule rec {
  pname = "glauth";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "glauth";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-kX/i156WxB2Ply4G0N/cR2KxrkEM/RdVXo0P5KMfHao=";
  };

  vendorSha256 = "sha256-3LQ4e1VwaDTns+bS2ibL5CCfGrRTRIYwykGsQsL/mDk=";

  modRoot = "v2";
  excludedPackages = [
    "vendored/toml"
  ];

  postInstall = ''
    rm $out/bin/plugins
  '';

  checkPhase = false;

  meta = with lib; {
    description = "A lightweight LDAP server";
    homepage = "https://glauth.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ an-empty-string ];
  };
}
