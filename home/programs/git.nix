{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Tris Emmy Wilson";
    userEmail = "tris@tris.fyi";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      advice.detachedHead = false;

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      merge.conflictStyle = "zdiff3";

      # https://blog.gitbutler.com/how-git-core-devs-configure-git/
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      push.default = "simple";
      push.autoSetupRemote = true;
      push.followTags = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;
      commit.verbose = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
    };
  };
}
