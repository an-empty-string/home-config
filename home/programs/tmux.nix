{ ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    extraConfig = ''
      # Statusline
      set -g status-interval 1
      set -g status-style "bg=colour187"
      set -g status-left "[#S] "
      set -g status-right "#[fg=black]#(whoami)@#h#[default] / %Y-%m-%d %H:%M:%S"
      set -g status-right-length 64

      # Window status
      setw -g window-status-format "#[fg=colour239]#I (#W)"
      setw -g window-status-current-format "#[fg=colour232,bold]#I (#W)"
    '';
  };
}
