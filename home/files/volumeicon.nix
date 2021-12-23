{ ... }: 

{
  target = ".config/volumeicon/volumeicon";
  text = ''
    [Alsa]
    card=default

    [Notification]
    show_notification=true
    notification_type=0

    [StatusIcon]
    stepsize=5
    onclick=pavucontrol
    theme=Default
    use_panel_specific_icons=false
    lmb_slider=true
    mmb_mute=true
    use_horizontal_slider=false
    show_sound_level=false
    use_transparent_background=false

    [Hotkeys]
    up_enabled=true
    down_enabled=true
    mute_enabled=true
    up=XF86AudioRaiseVolume
    down=XF86AudioLowerVolume
    mute=XF86AudioMute
  '';
}
