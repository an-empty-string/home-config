{ options, ... }:

{
  enable = true;
  pinentryFlavor = if options.graphicalEnvironment.enable then "gtk2" else "curses";

  enableSshSupport = options.gpg.sshEnable;
  sshKeys = if options.gpg.sshEnable then options.gpg.sshKeys else [];
}
