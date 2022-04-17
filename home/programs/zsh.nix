{ lib, options, ... }:

{
  enable = true;

  sessionVariables = lib.mkMerge [
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
    precmd() {
      PROMPT="%F{$promptColor}%n@%m %F{blue}%4~ %F{red}%B%#%f%b ";
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [ $? -eq 0 ]; then
        PROMPT="%F{magenta}(on $branch) $PROMPT"
      fi
    }
    RPROMPT="";

    export EDITOR="vim"
  '' + (if options.graphicalEnvironment.enable then ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '' else "");

  autocd = true;
  defaultKeymap = "viins";
  enableVteIntegration = true;
}
