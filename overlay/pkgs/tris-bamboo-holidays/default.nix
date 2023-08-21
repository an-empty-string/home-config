{ lib
, python311 }:

python311.pkgs.buildPythonApplication rec {
  name = "tris-bamboo-holidays";
  src = ./.;
  propagatedBuildInputs = with python311.pkgs; [ tris-config requests ];
}
