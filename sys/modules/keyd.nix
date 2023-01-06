{ pkgs, ... }: {
  systemd.services.keyd = {
    description = "key remapping daemon";
    serviceConfig.ExecStart = "${pkgs.keyd}/bin/keyd";
    wantedBy = ["multi-user.target"];
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    capslock = overload(capslock, esc)

    [chording]

    [capslock:C]
    # just to be very clear about what keys we definitely want C-[key] to work for
    c = C-c
    d = C-d
    r = C-r
    f = C-f
    t = C-t
    w = C-w
    ; = S-;
    space = enter

    u = pagedown
    i = pageup

    h = left
    j = down
    k = up
    l = right

    e = oneshot(meta)
    n = toggle(chording)
  '';
}
