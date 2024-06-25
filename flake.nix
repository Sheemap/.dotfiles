{
  description = "System config flake";

  inputs = {
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
    };
    #nixvim-local = {
    #  url = "git+file:///home/breadcat/Code/nixvim";
    #};

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      home-manager,
      nixvim-dev,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      localPkgs = {
        pyfa = pkgs.callPackage ./packages/pyfa.nix { };
        pants = pkgs.callPackage ./packages/pants.nix { };
      };
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosConfigurations = {
        breadbox = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs localPkgs;
          };
          modules = [
            ./hosts/breadbox/configuration.nix
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
            #nix-ld.nixosModules.nix-ld
            #inputs.home-manager.nixosModules.nixos
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
            nixvim-dev.homeManagerModules.nixvim
          ];
        };
        dinodave = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/dino-dave/home.nix
            nixvim-dev.homeManagerModules.nixvim
          ];
        };
        breadman = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/work-arch/home.nix
            nixvim-dev.homeManagerModules.nixvim
          ];
        };
      };
    };
}
