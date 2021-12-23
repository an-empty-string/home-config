{ options, ... }:

{
  enable = true;
  controlMaster = if options.ssh.useControlMaster then "auto" else "no";
  includes = [ "config.d/*" ];
}
