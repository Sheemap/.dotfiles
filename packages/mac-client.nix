{ pkgs }:
let
  pname = "mac-client";
  version = "0.1.0";

  src = pkgs.fetchurl {
    url = "https://github.com/MegaAntiCheat/client-backend/releases/download/v${version}/client_backend";
    hash = "sha256-qLL9kFs3YYq9+qHQl6nTmGoo1J2Yw1sdZLf5lE83y78=";
  };
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version src;

  dontUnpack = true;
  installPhase = ''
    install -Dm755 ${src} $out/bin/${pname}
  '';

  meta = {
    description = "Client backend for MegaAntiCheat";
    homepage = "https://github.com/MegaAntiCheat/client-backend";
    license = pkgs.lib.licenses.gpl3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
# Build from source
# Running into a lot of issues
# { pkgs }:
# let
#    pname = "mmac-client-backendac-client-backend";
#    version = "v0.1.0";

#    src = pkgs.fetchFromGitHub {
#     owner = "MegaAntiCheat";
#     repo = "client-backend";
#     rev = version;
#     hash = "sha256-koD6XnlmxYXQP/8c+FlKm3EzUOJJ6xJn2+1ikwr1NIM=";
#   };
# in
# pkgs.rustPlatform.buildRustPackage {
#     nativeBuildInputs = with pkgs; [
#         pkg-config
#     ];
#   inherit pname version src;
#   cargoLock.lockFile = "${src}/Cargo.lock";
#   cargoLock.outputHashes = {
#       "rcon-0.5.2" = "sha256-DJkINFgIsS94/ps5ahrilZkyphKjmR7a0xYDK2mFg0Y=";
#       "steam-language-gen-0.1.2" = "sha256-KcZdf0sDJMbPDxPCZkq85eQ+MmbHnr2LKc9B1qmLuz0=";
#       "tf-demo-parser-0.5.1" = "sha256-QEUd2yTIshS2H+XO8p1ggh22tox3jgPoYybrv0MhKL8=";
#   };
# }
