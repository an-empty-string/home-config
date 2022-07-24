{ ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    includes = [ "config.d/*" ];
  };
}
