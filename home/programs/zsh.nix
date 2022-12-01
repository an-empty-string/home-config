{ lib, ... }:

{
  programs.zsh = {
    enable = true;

    sessionVariables = {
      TERM = "xterm-256color";
    };

    initExtraFirst = ''
      setopt extended_glob

      promptColor="green"
      location=""
      if [ -n "$SSH_CLIENT" ]; then
        promptColor="yellow"
        location=": $(hostname)"
      else
        authSockCandidate="/run/user/$UID/gnupg/S.gpg-agent.ssh"
        if [ -e $authSockCandidate ]; then
          export SSH_AUTH_SOCK=$authSockCandidate
        fi
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

        print -Pn "\e]0;zsh$location: ''${PWD/$HOME/\~}\a"
      }
      preexec() {
        print -Pn "\e]0;$location$1\a"
      }
      RPROMPT="";

      export EDITOR="vim"
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
      export PATH="$PATH:$HOME/.local/share/gem/ruby/2.7.0/bin"

      alias -s {csv,tsv}=vd
      alias -s {png,jpg}=imv
      alias -s {txt,py,rb}=nvim

      if [ "$(tty)" = "/dev/tty1" ] && which sway > /dev/null; then
        exec sway
      fi
  '';

    autocd = true;
    defaultKeymap = "viins";
    enableVteIntegration = true;
  };
}
