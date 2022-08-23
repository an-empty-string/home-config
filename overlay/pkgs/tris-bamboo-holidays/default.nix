{ lib
, python310 }:

python310.pkgs.buildPythonApplication rec {
  name = "tris-bamboo-holidays";
  src = ./.;
  propagatedBuildInputs = with python310.pkgs; [ tris-config requests ];
}
