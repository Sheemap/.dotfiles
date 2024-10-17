{ pkgs }:

let
  container-name = "nix-http-store";
in
pkgs.dockerTools.buildLayeredImage {

  name = "registry.snazcat.com/${container-name}";
  tag = "latest";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "debian";
        imageDigest = "sha256:36e591f228bb9b99348f584e83f16e012c33ba5cad44ef5981a1d7c0a93eca22";
        sha256 = "sha256-Gu53khovNE0FBveEFK5itL3g3fZmbd8TYnyebq5D8po=";
        finalImageName = "debian";
        finalImageTag = "latest";
    };

  contents = with pkgs; [ nix-serve ];


  config = {

    Cmd = [
    "${pkgs.nix-serve}/bin/nix-serve -p 8080"
      # ''
      #     nixos-rebuild \
      #         --experimental-features 'nix-command flakes' \
      #         switch github:sheemap/.dotfiles#${container-name}
      # ''
      # ''
      #     nix build \
      #         --experimental-features 'nix-command flakes' \
      #         github:sheemap/.dotfiles#containers.${container-name}
      # ''
    ];

  };
}
