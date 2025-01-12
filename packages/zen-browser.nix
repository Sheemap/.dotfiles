{
  fetchurl,
  appimageTools,
  lib,
  buildFHSEnv,
}:
let
  pname = "zen";
  version = "1.6b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/1.6b/zen-x86_64.AppImage";
    hash = "sha256-9HxRnx4dQmvEqOdVI870TaXEko9PqK2srhg4IlUwSps=";
  };
in
buildFHSEnv {
  inherit pname version src;
  targetPkgs = pkgs: [ pkgs.appimage-run ] ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs;

  runScript = "appimage-run ${src} --";

  meta = with lib; {
    description = "Experience tranquillity while browsing the web without people tracking you!";
    homepage = "https://github.com/zen-browser/desktop";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "zen";
  };
}
