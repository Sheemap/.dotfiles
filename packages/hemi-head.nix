{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
  lib ? pkgs.lib,
  stdenvNoCC ? pkgs.stdenvNoCC,
  fetchzip ? pkgs.fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "hemi-head";
  version = "1.0.0";

  src = fetchzip {
    url = "https://dl.dafont.com/dl/?f=hemi_head";
    hash = "sha256-oGd2CJ4ISpHTj18VdXKmGMOngO1OmBH6XrW0N0Fr6eg=";
    extension = "zip";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ *.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Hemi Head font";
    homepage = "https://www.dafont.com/hemi-head.font";
    # TODO: Include their pdf license, its included in the zip we download
    #license = [ licenses.bsd3 licenses.ofl ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
