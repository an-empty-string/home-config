{ ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    extraConfig = ''
      SetEnv TERM=xterm-256color
    '';
    includes = [ "config.d/*" ];
  };
}
