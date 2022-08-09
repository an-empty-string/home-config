{ pkgs, ... }:
let
  task = "${pkgs.taskwarrior}/bin/task";
  ntfy = "${pkgs.ntfy}/bin/ntfy";
  jq = "${pkgs.jq}/bin/jq";

  nightly = pkgs.writeShellScriptBin "nightly" ''
      ${task} rc.bulk=0 status:completed modify -today
      ${task} rc.bulk=0 +today modify -today +hanging
      ${task} rc.bulk=0 +tomorrow modify -tomorrow +today

      hangingCount=$(${task} count status:pending +hanging)
      overdueCount=$(${task} count status:pending +OVERDUE)
      inboxCount=$(${task} count status:pending +inbox)

      if [[ $hangingCount -eq 0 && $overdueCount -eq 0 && $inboxCount -eq 0 ]]; then
        ${ntfy} -t 'Daily task report' send 'Good morning! No overdue, hanging, or inboxed tasks today. 🥳'
      else
        ${ntfy} -t 'Daily task report' send 'Good morning!'" $overdueCount overdue, $hangingCount hanging, $inboxCount inboxed."
      fi

      task sync
    '';

  frequently = pkgs.writeShellScriptBin "frequently" ''
    ${task} 'notify<now' status:pending export | jq -r ".[].description" | while read line; do
      ${ntfy} -t 'Task notification' send "$line"
    done

    ${task} rc.bulk=0 'notify<now' status:pending +notify_only done
    ${task} rc.bulk=0 'notify<now' status:pending modify notify:

    ${task} sync
  '';
in

{
  systemd.user.services.periodic-nightly = {
    Unit.Description = "Run nightly periodic scripts";
    Service.ExecStart = "${nightly}/bin/nightly";
  };

  systemd.user.services.periodic-frequent = {
    Unit.Description = "Run frequent periodic scripts";
    Service.ExecStart = "${frequently}/bin/frequently";
  };

  systemd.user.timers.periodic-nightly = {
    Unit.Description = "Scheduled run for nightly periodic scripts";
    Timer.OnCalendar = "11:00:00 UTC";
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.periodic-frequent = {
    Unit.Description = "Scheduled run for frequent periodic scripts";
    Timer.OnCalendar = "*:0/5";
    Install.WantedBy = [ "default.target" ];
  };
}
