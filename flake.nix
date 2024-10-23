{
  description = "System config flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # True Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-dev = {
      url = "github:sheemap/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim-local = {
    #   url = "git+file:///home/breadcat/Code/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs-master";
    # };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      home-manager,
      nixvim,
      treefmt-nix,
      lix-module,
      zen-browser,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      localPkgs = {
        pyfa = pkgs.callPackage ./packages/pyfa.nix { };
        pants = pkgs.callPackage ./packages/pants.nix { };
        mac-client = pkgs.callPackage ./packages/mac-client.nix { };

        zen-browser = zen-browser.packages.x86_64-linux.specific;
      };

      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      # The set of systems to provide outputs for
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems =
        f: nixpkgs.lib.genAttrs allSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      packages = forAllSystems (
        { pkgs }:
        {
          pants = pkgs.callPackage ./packages/pants.nix { inherit pkgs; };
          mac-client = pkgs.callPackage ./packages/mac-client.nix { inherit pkgs; };
        }
      );

      containers = {
        nix-http-store = pkgs.callPackage ./containers/nix-http-store.nix { };
      };

      nixosConfigurations = {
        breadbox = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs localPkgs;
          };
          modules = [
            ./hosts/breadbox/configuration.nix
            lix-module.nixosModules.default
            #nix-ld.nixosModules.nix-ld
            #inputs.home-manager.nixosModules.nixos
          ];
        };
        dino-dave = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs localPkgs;
          };
          modules = [
            ./hosts/dino-dave/configuration.nix
            lix-module.nixosModules.default
          ];
        };
      };

      homeConfigurations = {
        breadcat = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/breadbox/home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
        dinodave = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/dino-dave/home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
        breadman = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/work-arch/home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
      };
    };
}
