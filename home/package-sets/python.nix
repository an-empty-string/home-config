{ options, ... }:

if options.python.enable then [
  (options.python.package.withPackages (p: with p; [
    requests
    ipython
  ] ++ (options.python.additionalPythonPackages p)))
] else []
