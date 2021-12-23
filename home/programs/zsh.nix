{ lib, options, ... }:

{
  enable = true;

  sessionVariables = lib.mkMerge [
    {
      PROMPT = "%F{green}%n@%m %F{blue}%4~ %F{red}%B%#%f%b ";
      RPROMPT = "";
    }
    (lib.mkIf options.graphicalEnvironment.enable {
      TERM = "xterm-256color";
    })
  ];

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
