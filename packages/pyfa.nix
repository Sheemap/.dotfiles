{
  fetchurl,
  appimageTools,
  lib,
}:
let
  pname = "pyfa";
  version = "2.58.3";

  src = fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/${pname}-v${version}-linux.AppImage";
    hash = "sha256-opzZSiVWfJv//KONocL9byZKqX/hWkPU+ssdceUDXh0=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [ pkgs.libnotify ];
  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 444 -D ${contents}/pyfa.desktop -t $out/share/applications

      substituteInPlace $out/share/applications/pyfa.desktop \
        --replace "Exec=usr/bin/python3.11" "Exec=${pname}"

      cp -r ${contents}/usr/share/* $out/share

    '';

  meta = with lib; {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pyfa";
  };
}
