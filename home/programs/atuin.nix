{ ... }: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      enter_accept = false;
      prefers_reduced_motion = true;
      inline_height = 20;
      style = "compact";
      common_prefix = [ "doas" ];
    };
  };
}
