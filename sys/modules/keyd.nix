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
    capslock = timeout(overload(navigation, esc), 500, toggle(navigation))
    rightshift = layer(rshift)

    [chording]

    [navigation:C]
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

    1 = f1
    2 = f2
    3 = f3
    4 = f4
    5 = f5
    6 = f6
    7 = f7
    8 = f8
    9 = f9
    0 = f10
    minus = f11
    equals = f12

    e = oneshot(meta)
    n = toggle(chording)
    rightshift = toggle(navigation)

  '';
}
