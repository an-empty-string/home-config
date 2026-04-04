{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    colorTheme = "light-256";
    config = {
      news.version = "2.6.0";
      default.command = "act";
      calendar.holidays = "full";

      report.act = {
        description = "Unblocked tasks by project";
        columns = "id,project,priority,description.count,tags,due.relative";
        labels = "ID,Proj,Pri,Desc,Tags,Due";
        sort = "project+/,priority-,entry+";
        filter = "status:pending -WAITING -BLOCKED";
      };

      alias.cal = "calendar";
      alias.next = "next limit:1";

      alias.inbox = "add +inbox";
      alias.inboxed = "act +inbox";

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
        today = { read = "+today"; };
      };

      nag = "";
      verbose = "label,affected,footnote,blank,new-id";
    };
  };

  home.packages = with pkgs; [
    timewarrior
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
}
