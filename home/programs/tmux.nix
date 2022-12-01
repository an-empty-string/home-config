{ ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    extraConfig = ''
      # Statusline
      set -g status-interval 1
      set -g status-style "bg=colour237"
      set -g status-left "[#S] "
      set -g status-right "#[fg=white,bold]#(whoami)@#h#[default] / %Y-%m-%d %H:%M:%S"
      set -g status-right-length 64

      # Window status
      setw -g window-status-format "#[fg=colour245]#I (#W)"
      setw -g window-status-current-format "#[fg=colour255,bold]#I (#W)"
    '';
  };
}
