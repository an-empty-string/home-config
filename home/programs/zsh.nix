{ lib, ... }:

{
  enable = true;

  sessionVariables = {
    TERM = "xterm-256color";
  };

  initExtraFirst = ''
    setopt extended_glob

    promptColor="green"
    if [ -n "$SSH_CLIENT" ]; then
      promptColor="yellow"
    fi

    authSockCandidate="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    if [ -e $authSockCandidate ]; then
      export SSH_AUTH_SOCK=$authSockCandidate
    fi
  '';

  initExtra = ''
    eval "$(direnv hook zsh)"
    alias ls="ls --color=auto"
    precmd() {
      PROMPT="%F{$promptColor}%n@%m %F{blue}%4~ %F{red}%B%#%f%b ";
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [ $? -eq 0 ]; then
        PROMPT="%F{magenta}(on $branch) $PROMPT"
      fi
    }
    RPROMPT="";

    export EDITOR="vim"

    if [ "$(tty)" = "/dev/tty1" ] && which sway > /dev/null; then
      exec sway
    fi
  '';

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
