{ lib
, python312 }:

python312.pkgs.buildPythonApplication rec {
  name = "tris-bamboo-holidays";
  src = ./.;
  propagatedBuildInputs = with python312.pkgs; [ tris-config requests ];

  pyproject = true;
  build-system = [ python312.pkgs.setuptools ];
}
