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
    #nix-ld = {
    #  url = "github:Mic92/nix-ld";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    #nix-ld,
    ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    
      nixosConfigurations = {
	breadbox = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
            ./hosts/breadbox/configuration.nix
	    #nix-ld.nixosModules.nix-ld
            #inputs.home-manager.nixosModules.nixos
          ];
	};
	dino-dave = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
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
          modules = [ 
	    ./hosts/breadbox/home.nix
	    nixvim.homeManagerModules.nixvim
          ];
	};
        dinodave = home-manager.lib.homeManagerConfiguration {
	  inherit pkgs;
          modules = [ 
	    ./hosts/dino-dave/home.nix
	    nixvim.homeManagerModules.nixvim
          ];
	};
        work-arch = home-manager.lib.homeManagerConfiguration {
	  inherit pkgs;
          modules = [ 
            ./hosts/work-arch/home.nix
	    nixvim.homeManagerModules.nixvim
          ];
	};
      };
    };  
}
