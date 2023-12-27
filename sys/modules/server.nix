{ pkgs, ... }: {
  users.users.alyssa = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgpVY7X8AL0oHJaZIFy9Lfp9KaNsVqVi7e+X+CIAWd6"
    ];
  };

  users.users.philo = {
    uid = 1002;
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      
    ];
  };

  users.users.hunter = {
    uid = 3199;
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBG8RmADAb6jH4agL6YUn0PiDVRJhKWds1P433m0N//8ExPsgdw02eJz40HVJtTOsUhXOA+3/6I0PC91wmbDUCkq+32cD8qYQQxXzAhqHgKsGECqvmfufn30Y2zrLR3loQMDtTojrgHExS33rO6/GnpLSUaQZ3XTmXzXaXryJDlPAeEpboabTQs29JnEvfK5Xv5grpKLHthJ4xw/hPqNSPqS3zQWdGdl71TSfopmNM1Wg0RAhgP4mHgfbPqXFpvnKtCpYfVSao49QDJck5D+KHNhFrkegVFHSSJ9rdjksUUP0ZBlQPlQeQsjLCLx7EWjgJ6gU23maDaJ6Ra82CSVxH hf0002@ppppowerbook"
    ];
  };
}
