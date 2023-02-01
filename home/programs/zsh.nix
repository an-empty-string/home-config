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

      jr() {
        date "+%Y-%m-%d %H:%M:%S" >> ~/journal.txt
        if [[ $# -gt 0 ]]; then
          echo "$@" >> ~/journal.txt
          echo >> ~/journal.txt
        else
          cat >> ~/journal.txt
        fi
      }

      bt() {
        if [[ $1 = earbuds ]]; then
          mac=AC:12:2F:CF:96:86
        elif [[ $1 = headphones ]]; then
          mac=AC:12:2F:AC:C7:A4
        else
          echo "earbuds/headphones?"
          return
        fi

        mosquitto_pub -h hsv1 -t bluetooth/all -m "disconnect $mac"
        sleep 2
        bluetoothctl disconnect || true
        bluetoothctl connect $mac
      }

      tasknote() {
        mkdir -p ~/vimwiki/tasknotes
        uuid=$(task $1 uuids)
        desc=$(task _get ''${uuid}.description)
        note=~/vimwiki/tasknotes/$uuid.wiki

        if [[ ! -f $note ]]; then
          echo "* [[''${uuid}|''${desc}]]" >> ~/vimwiki/tasknotes/index.wiki
          echo "== ''${desc} ==" > $note
        fi

        vim $note
      }

      if [ "$(tty)" = "/dev/tty1" ] && which sway > /dev/null; then
        exec sway
      fi
  '';

    autocd = true;
    defaultKeymap = "viins";
    enableVteIntegration = true;
  };
}
