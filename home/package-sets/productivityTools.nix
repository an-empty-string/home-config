{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    config = {
      news.version = "2.6.0";
      default.command = "act";

      report.act = {
        description = "Unblocked tasks by project";
        columns = "id,project,priority,description,tags,due.relative";
        labels = "ID,Proj,Pri,Desc,Tags,Due";
        sort = "project+/,priority-,entry+";
        filter = "status:pending project!=misc -WAITING -BLOCKED -someday";
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
        filter = "+today status:pending -WAITING -BLOCKED";
      };
      alias.next = "next limit:1";

      uda.priority.values = "N,H,M,,L,S";

      context.personal = let ctx = "proj:personal"; in { read = ctx; write = ctx; };
      context.cyburity = let ctx = "proj:work.cyburity"; in { read = ctx; write = ctx; };
      context.as = let ctx = "proj:work.as"; in { read = ctx; write = ctx; };
      context.cat = let ctx = "proj:cat"; in { read = ctx; write = ctx; };

      nag = "";
      verbose = "label,affected,footnote,blank,new-id";
    };
  };

  home.packages = with pkgs; [
    tris-pomodoro
  ];

  home.activation.writeMutableTaskrc = ''
    echo 'include ~/.config/task/taskrc' > ~/.taskrc
    echo 'include ~/.taskrc-secret' >> ~/.taskrc
    touch ~/.taskrc-secret
  '';

  home.file.taskwarriorMQTTHook = {
    source = ../files/taskwarrior-on-exit-mqtt;
    target = ".local/share/task/hooks/on-exit.mqtt";
    executable = true;
  };

  systemd.user.services.taskwarrior-sync = {
    Unit.Description = "Synchronize taskwarrior tasks";
    Service.ExecStart = "${pkgs.taskwarrior}/bin/task sync";
  };

  systemd.user.timers.taskwarrior-sync = {
    Unit.Description = "Synchronize taskwarrior tasks periodically";
    Timer.OnCalendar = "*:0/10";
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.tris-pomodoro-server = {
    Unit.Description = "Pomodoro server";
    Service.ExecStart = "${pkgs.tris-pomodoro}/bin/pomodoro-server";
    Install.WantedBy = [ "default.target" ];
  };
}
