{ options, ... }:

{
  enable = true;
  userName = options.displayName;
  userEmail = options.emailAddress;

  extraConfig = ''
    [pull]
    rebase=true
  '';
}
