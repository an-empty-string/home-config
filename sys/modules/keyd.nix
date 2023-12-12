{ pkgs, ... }: {
  systemd.services.keyd = {
    description = "key remapping daemon";
    serviceConfig.ExecStart = "${pkgs.keyd}/bin/keyd";
    wantedBy = ["multi-user.target"];
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    046d:4051
    *

    [global]
    layer_indicator = 1

    [main]
    mouse1 = layer(navigation)
    capslock = overload(navigation, esc)
    rightshift = layer(rs)

    [rs:S]
    escape = ~

    [navigation:C]
    # just to be very clear about what keys we definitely want C-[key] to work for
    c = C-c
    d = C-d
    r = C-r
    f = C-f
    t = C-t
    w = C-w
    ; = S-;
    space = oneshot(spaces)

    enter = S-M-enter

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
    equal = f12

    e = oneshot(meta)
    n = toggle(macros_enabled)
    q = toggle(functions)
    m = oneshot(media)
    rightshift = toggle(navigation)

    [spaces]
    h = S-home
    space = enter

    [media]
    h = previoussong
    k = playpause
    l = nextsong

    rightshift = toggle(media)

    [functions]
    w = f13
    e = C-A-a
    s = f15
    f = C-S-i

    rightshift = toggle(functions)

    [macros_enabled]
    rightshift = overload(macro, toggle(macros_enabled))

    [macro:S]
    i = macro(import space)
    s = macro(systemctl space)
    o = macro(C-S-u 00b0 space)
  '';
}
