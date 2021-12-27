{ lib, options, ... }:

{
  enable = true;

  sessionVariables = lib.mkMerge [
    {
      PROMPT = "%F{\${promptColor}}%n@%m %F{blue}%4~ %F{red}%B%#%f%b ";
      RPROMPT = "";
    }
    (lib.mkIf options.graphicalEnvironment.enable {
      TERM = "xterm-256color";
    })
    (lib.mkIf options.gpg.sshEnable {
      SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent.ssh";
    })
  ];

  initExtraFirst = ''
    promptColor="green"
    if [ -n "$SSH_CLIENT" ]; then
      promptColor="yellow"
    fi
  '';

  initExtra = ''
    eval "$(direnv hook zsh)"
    alias ls="ls --color=auto"
  '';

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
