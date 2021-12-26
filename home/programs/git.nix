{ options, ... }:

{
  enable = true;
  userName = options.displayName;
  userEmail = options.emailAddress;

  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = true;
  };
}
