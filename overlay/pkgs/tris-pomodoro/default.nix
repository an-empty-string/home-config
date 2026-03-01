{ lib
, python3 }:

python3.pkgs.buildPythonApplication rec {
  name = "tris-pomodoro";
  src = ./.;
  propagatedBuildInputs = with python3.pkgs; [ aiomqtt ];

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];
}
