{ ... }:

{
  enable = true;
  mutableKeys = true;
  mutableTrust = true;
  publicKeys = [
    { source = ../../trust/gpg/tris.asc; trust = 5; }
  ];

  settings = {
    personal-cipher-preferences = "AES256 AES192 AES";
    personal-digest-preferences = "SHA512 SHA384 SHA256";
    personal-compress-preferences = "Uncompressed ZLIB BZIP2 ZIP";
    default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES Uncompressed ZLIB BZIP2";
    cert-digest-algo = "SHA512";
    s2k-digest-algo = "SHA512";
    s2k-cipher-algo = "AES256";
    charset = "utf-8";
    fixed-list-mode = true;
    no-comments = true;
    keyid-format = "0xlong";
    list-options = "show-uid-validity";
    verify-options = "show-uid-validity";
    with-fingerprint = true;
    require-cross-certification = true;
    no-symkey-cache = true;
  };
}
