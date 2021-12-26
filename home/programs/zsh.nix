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
    (lib.mkIf options.gpg.sshEnable {
      SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent.ssh";
    })
  ];

  initExtra = ''
    eval "$(direnv hook zsh)"
  '';

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
