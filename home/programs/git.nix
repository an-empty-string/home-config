{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Tris Emmy Wilson";
    userEmail = "tris@tris.fyi";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      advice.detachedHead = false;
    };
  };
}
