{
  fetchurl,
  pkgs,
  lib,
}:
let
  pname = "pants";
  version = "0.12.0";

  scie-pants = pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/pantsbuild/scie-pants/releases/download/v${version}/scie-${pname}-linux-x86_64";
      hash = "sha256-9PjgobndxVqDTYGtw1HESrtzwzH2qE9zFwR26xtwZrM=";
    };

    phases = ["installPhase" "patchPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/pants
      chmod +x $out/bin/pants
    '';
  };
in
pkgs.buildFHSUserEnv  {
  name = "pants";

  targetPackages = with pkgs; [
    python3
  ];

  runScript = "${scie-pants}/bin/pants";
  profile = ''
    export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
  '';

  meta = with lib; {
    description = "Protects your Pants from the elements";
    homepage = "https://github.com/pantsbuild/scie-pants";
    license = licenses.asl20;
    maintainers = [];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pants";
  };
}
