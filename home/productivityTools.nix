{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    config = {
      news.version = "2.6.0";
      default.command = "act";
      calendar.holidays = "full";

      report.act = {
        description = "Unblocked tasks by project";
        columns = "id,project,priority,size,description.count,tags,due.relative";
        labels = "ID,Proj,Pri,Size,Desc,Tags,Due";
        sort = "project+/,priority-,size-,entry+";
        filter = "status:pending project!=misc -WAITING -BLOCKED -someday -notify_only";
      };

      report.booklist = {
        description = "Book list";
        columns = "id,description,tags,entry";
        labels = "ID,Desc,Tags,Entered";
        sort = "entry+";
        filter = "status:pending -WAITING -BLOCKED proj:misc.booklist";
      };

      report.next = {
        description = "What to work on next";
        columns = "id,project,description";
        labels = "ID,Proj,Desc";
        filter = "+today status:pending -WAITING -BLOCKED -notify_only";
      };

      alias.cal = "calendar";
      alias.next = "next limit:1";

      color.tag = {
        today = "rgb140";  # brightish green
        tomorrow = "rgb120";  # a little darker green
      };

      uda.priority.values = "N,H,M,,L,S";

      uda.size.label = "Size";
      uda.size.type = "string";
      uda.size.values = ",xs,sm,md,lg,xl";

      uda.notify.type = "date";
      uda.notify.label = "Notify";

      context = let mkCtx = (ctx: { read = ctx; write = ctx; }); in {
        personal = mkCtx "proj:personal";
        cyburity = mkCtx "proj:work.cyburity";
        as = mkCtx "proj:work.as";
        cat = mkCtx "proj:cat";
        home = { read = "proj:personal or proj:work.as"; };
      };

      nag = "";
      verbose = "label,affected,footnote,blank,new-id";
    };
  };

  home.packages = with pkgs; [
    tris-pomodoro
    tris-bamboo-holidays
  ];

  home.activation.writeMutableTaskrc = ''
    echo 'include ~/.config/task/taskrc' > ~/.taskrc
    echo 'include ~/.taskrc-secret' >> ~/.taskrc
    echo 'include ~/.holidays' >> ~/.taskrc
    touch ~/.taskrc-secret
    touch ~/.holidays
  '';

  home.file.taskwarriorMQTTHook = {
    source = files/taskwarrior-on-exit-mqtt;
    target = ".local/share/task/hooks/on-exit.mqtt";
    executable = true;
  };

  systemd.user.services.taskwarrior-sync = {
    Unit.Description = "Synchronize taskwarrior tasks";
    Service.Environment = ''PATH="${pkgs.taskwarrior}/bin:${pkgs.mosquitto}/bin"'';
    Service.ExecStart = "${pkgs.taskwarrior}/bin/task sync";
  };

  systemd.user.timers.taskwarrior-sync = {
    Unit.Description = "Synchronize taskwarrior tasks periodically";
    Timer.OnCalendar = "*:0/10";
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.bamboo-holidays-update = {
    Unit.Description = "Update holiday data from BambooHR";
    Service.ExecStart = "${pkgs.tris-bamboo-holidays}/bin/bamboo-holidays-update";
  };

  systemd.user.timers.bamboo-holidays-update = {
    Unit.Description = "Periodically update holiday data from BambooHR";
    Timer.OnCalendar = "0/4:0";
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.tris-pomodoro-server = {
    Unit.Description = "Pomodoro server";
    Service.ExecStart = "${pkgs.tris-pomodoro}/bin/pomodoro-server";
    Install.WantedBy = [ "default.target" ];
  };
}
