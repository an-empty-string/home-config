{ lib
, python3 }:

python3.pkgs.buildPythonApplication rec {
  name = "tris-mqtt-bluetooth";
  src = ./.;
  propagatedBuildInputs = with python3.pkgs; [ asyncio-mqtt ];
}
