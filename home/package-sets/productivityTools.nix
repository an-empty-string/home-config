{ pkgs, options, ... }: {
  programs.taskwarrior = {
    enable = true;
    config = {
      news.version = "2.6.0";
      default.command = "simple";

      report.simple = {
        description = "Unblocked tasks by project";
        columns = "id,project,priority,description,tags,due.relative";
        labels = "ID,Proj,Pri,Desc,Tags,Due";
        sort = "project+/,priority,entry+";
        filter = "status:pending -WAITING -BLOCKED";
      };

      context.prod.read = "project!=personal.book and project!=personal.code";

      context.cyburity = let ctx = "proj:work.cyburity"; in { read = ctx; write = ctx; };
      context.as = let ctx = "proj:work.as"; in { read = ctx; write = ctx; };

      taskd = options.productivityTools.taskd;
    };
  };

  home.packages = with pkgs; [
    # python39Packages.bugwarrior
    timewarrior
    tris-pomodoro
  ];

  home.file.timewarriorTaskwarriorHook = {
    source = ../files/on-modify.timewarrior;
    target = ".local/share/task/hooks/on-modify.timewarrior";
    executable = true;
  };

  home.activation.writeMutableTaskrc = "echo 'include ~/.config/task/taskrc' > ~/.taskrc";

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

  home.file.bugwarriorrc = {
    source = ../files/bugwarriorrc;
    target = ".config/bugwarrior/bugwarriorrc";
  };
}
