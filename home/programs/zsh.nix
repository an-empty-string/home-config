{ ... }:

{
  enable = true;

  sessionVariables = {
    PROMPT = "%F{green}%n@%m %F{blue}%4~ %F{red}%B%#%f%b ";
    RPROMPT = "";
  };

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
