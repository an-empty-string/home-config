{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    config = {
      news.version = "2.6.0";
      default.command = "simple";

      report.simple = {
        description = "Unblocked tasks by project";
        columns = "id,project,priority,description,due.relative";
        labels = "ID,Proj,Pri,Desc,Due";
        sort = "project+/,priority,entry+";
        filter = "status:pending -WAITING -BLOCKED";
      };

      context.prod.read = "project!=personal.book and project!=personal.code";
    };
  };

  home.packages = with pkgs; [
    timewarrior
    python39Packages.bugwarrior
  ];

  home.file.timewarriorTaskwarriorHook = {
    source = ../files/on-modify.timewarrior;
    target = ".local/share/task/hooks/on-modify.timewarrior";
    executable = true;
  };

  home.activation.writeMutableTaskrc = "echo 'include ~/.config/task/taskrc' > ~/.taskrc";
}
