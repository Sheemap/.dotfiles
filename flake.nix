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

    # NixOS Stable
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
    };

    nixgl.url = "github:nix-community/nixgl";

    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-dev = {
      url = "github:sheemap/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim-local = {
    #   url = "git+file:///home/breadcat/Code/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs-master";
    # };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      # Get the version of lix from this link. Within the "Using the Lix NixOS module" section
      # https://lix.systems/add-to-config/
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    ccase = {
      url = "github:rutrum/ccase";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:sheemap/zen-browser-flake";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      systems,
      home-manager,
      musnix,
      nixgl,
      nixvim,
      nixos-generators,
      treefmt-nix,
      lix-module,
      ccase,
      zen-browser,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
      localPkgs = {
        ccase = ccase.packages.${system}.default;
        pyfa = pkgs.callPackage ./packages/pyfa.nix { };
        pants = pkgs.callPackage ./packages/pants.nix { };
        mac-client = pkgs.callPackage ./packages/mac-client.nix { };
        plexamp = pkgs.callPackage ./packages/plexamp.nix { };
        #zen-browser = pkgs.callPackage ./packages/zen-browser.nix { };
        zen-browser = zen-browser.packages.${system}.default;
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
          zen-browser = pkgs.callPackage ./packages/zen-browser.nix { };
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
            musnix.nixosModules.musnix
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
            #lix-module.nixosModules.default
          ];
        };
        caroline = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs localPkgs;
          };
          modules = [
            ./hosts/caroline/configuration.nix
            # lix-module.nixosModules.default
          ];
        };
      };

      homeConfigurations = {
        breadgirl = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/breadbox/home.nix
            nixvim.homeManagerModules.nixvim
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                ];
              }
            )
          ];
        };
        arch-breadgirl = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs;
          };
          modules = [
            ./hosts/archcrafty/home.nix
            nixvim.homeManagerModules.nixvim
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                ];
              }
            )
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
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                ];
              }
            )
          ];
        };
        breadman = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit localPkgs nixgl;
          };
          modules = [
            ./hosts/work-arch/home.nix
            nixvim.homeManagerModules.nixvim
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                ];
              }
            )
          ];
        };
      };

      # Raw image that can be dd'd onto an sd card to boot
      # Then use colmena to manage further
      images.rpi = nixos-generators.nixosGenerate rec {
        system = "aarch64-linux";
        # specialArgs = {
        #     pkgs = nixpkgs-stable.legacyPackages.${system};
        # };
        modules = [
          {
            # Pin nixpkgs to the flake input, so that the packages installed
            # come from the flake inputs.nixpkgs-stable.url. nix.registry.nixpkgs.flake = nixpkgs-stable;
            # set disk size to to 50G
            virtualisation.diskSize = 50 * 1024;
          }
          # Apply the rest of the config.
          (_: {
            config = {
              nixpkgs.buildPlatform.system = "x86_64-linux";
              nixpkgs.hostPlatform.system = "aarch64-linux";

              time.timeZone = "America/Denver";
              sdImage.compressImage = false;

              users.users.breadcat = {
                isNormalUser = true;
                extraGroups = [
                  "networkmanager"
                  "wheel"
                ];
                openssh.authorizedKeys.keys = [
                  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC39e35rSFi11cR0pSERmyOOVqOkUp5Y6/OmUJi322BK94sZPZtJz99wo1EToDAj1waH0etOFAM5vWv4grthSAqx/xjiSP0BNeR7RkBxPjjJShBbCVF9wXUt7OiVDPG8/tptbwdzZP5lVjAzYMNmBJxtQt4Tyb30sPW4Ta/la3g+dm5vwrkQjFjyOU9fHRCY4evYerplTCzaV28Bxd0nOoi2X5TcZ2a+tW+8yNV0bGos7WyimlJ5+YMGJ0GVYS4Gkx6IHdjaRCzSJo6w7eSzybG+kRyQYSP+z0DEXtpHprV5GFfDAOvdTj0IfyfQbm8addXzFGvY3CMLa0H3PZnhimYm5o8m/G4oECnPsI8pjHGBKrZoq8QQg/HBLOPYRDKJjYIqVNCuJP+al00t7TC1HSbjY4yoQf91RFVfop2XajseYXHdKfMaE2fKN6MYhJS8zo+He5ItmMX0QY6+BcAxMu8v5TU5Ny2oDBFcU/czcNLDPGESlA5Ue/l9Ck4Yvh8LeM= breadcat"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbQriNUdqa3a1EFH4Al46szdlHon2nrDxwW1jOLuWQ9 breadcat"
                ];

              };

              system.stateVersion = "24.11";
              nix.settings.trusted-users = [
                "root"
                "breadcat"
              ];

              services.openssh.enable = true;

              networking = {
                wireless.enable = false;
                useDHCP = true;
              };
            };
          })
        ];
        format = "sd-aarch64";
      };
      colmena = {
        meta = {
          nixpkgs = import nixpkgs-stable {
            system = "aarch64-linux";
            overlays = [ ];
          };
        };
        defaults =
          { pkgs, ... }:
          {
            system.stateVersion = "24.11";
            nix.settings.trusted-users = [
              "root"
              "breadcat"
            ];

            environment.systemPackages = with pkgs; [
              vim
              neovim
              wget
              curl
              fish
            ];

            services.openssh.enable = true;

            users.users.breadcat = {
              isNormalUser = true;
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
              openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC39e35rSFi11cR0pSERmyOOVqOkUp5Y6/OmUJi322BK94sZPZtJz99wo1EToDAj1waH0etOFAM5vWv4grthSAqx/xjiSP0BNeR7RkBxPjjJShBbCVF9wXUt7OiVDPG8/tptbwdzZP5lVjAzYMNmBJxtQt4Tyb30sPW4Ta/la3g+dm5vwrkQjFjyOU9fHRCY4evYerplTCzaV28Bxd0nOoi2X5TcZ2a+tW+8yNV0bGos7WyimlJ5+YMGJ0GVYS4Gkx6IHdjaRCzSJo6w7eSzybG+kRyQYSP+z0DEXtpHprV5GFfDAOvdTj0IfyfQbm8addXzFGvY3CMLa0H3PZnhimYm5o8m/G4oECnPsI8pjHGBKrZoq8QQg/HBLOPYRDKJjYIqVNCuJP+al00t7TC1HSbjY4yoQf91RFVfop2XajseYXHdKfMaE2fKN6MYhJS8zo+He5ItmMX0QY6+BcAxMu8v5TU5Ny2oDBFcU/czcNLDPGESlA5Ue/l9Ck4Yvh8LeM= breadcat"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbQriNUdqa3a1EFH4Al46szdlHon2nrDxwW1jOLuWQ9 breadcat"
              ];

            };
            users.users.root = {
              openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC39e35rSFi11cR0pSERmyOOVqOkUp5Y6/OmUJi322BK94sZPZtJz99wo1EToDAj1waH0etOFAM5vWv4grthSAqx/xjiSP0BNeR7RkBxPjjJShBbCVF9wXUt7OiVDPG8/tptbwdzZP5lVjAzYMNmBJxtQt4Tyb30sPW4Ta/la3g+dm5vwrkQjFjyOU9fHRCY4evYerplTCzaV28Bxd0nOoi2X5TcZ2a+tW+8yNV0bGos7WyimlJ5+YMGJ0GVYS4Gkx6IHdjaRCzSJo6w7eSzybG+kRyQYSP+z0DEXtpHprV5GFfDAOvdTj0IfyfQbm8addXzFGvY3CMLa0H3PZnhimYm5o8m/G4oECnPsI8pjHGBKrZoq8QQg/HBLOPYRDKJjYIqVNCuJP+al00t7TC1HSbjY4yoQf91RFVfop2XajseYXHdKfMaE2fKN6MYhJS8zo+He5ItmMX0QY6+BcAxMu8v5TU5Ny2oDBFcU/czcNLDPGESlA5Ue/l9Ck4Yvh8LeM= breadcat"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbQriNUdqa3a1EFH4Al46szdlHon2nrDxwW1jOLuWQ9 breadcat"
              ];

            };

            deployment.replaceUnknownProfiles = false;
          };

        rpi-media =
          {
            name,
            nodes,
            pkgs,
            ...
          }:
          {
            time.timeZone = "America/Denver";
            # boot.loader.generic-extlinux-compatible.enable = true;
            # boot.initrd.availableKernelModules = [ "xhci_pci" ];
            # boot.initrd.kernelModules = [ ];
            # boot.kernelModules = [ ];
            # boot.extraModulePackages = [ ];

            services.xserver.desktopManager.gnome.enable = true;
            services.xserver.displayManager.gdm.enable = true;
            services.gnome.core-utilities.enable = false;

            users.users.root = {
              openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC39e35rSFi11cR0pSERmyOOVqOkUp5Y6/OmUJi322BK94sZPZtJz99wo1EToDAj1waH0etOFAM5vWv4grthSAqx/xjiSP0BNeR7RkBxPjjJShBbCVF9wXUt7OiVDPG8/tptbwdzZP5lVjAzYMNmBJxtQt4Tyb30sPW4Ta/la3g+dm5vwrkQjFjyOU9fHRCY4evYerplTCzaV28Bxd0nOoi2X5TcZ2a+tW+8yNV0bGos7WyimlJ5+YMGJ0GVYS4Gkx6IHdjaRCzSJo6w7eSzybG+kRyQYSP+z0DEXtpHprV5GFfDAOvdTj0IfyfQbm8addXzFGvY3CMLa0H3PZnhimYm5o8m/G4oECnPsI8pjHGBKrZoq8QQg/HBLOPYRDKJjYIqVNCuJP+al00t7TC1HSbjY4yoQf91RFVfop2XajseYXHdKfMaE2fKN6MYhJS8zo+He5ItmMX0QY6+BcAxMu8v5TU5Ny2oDBFcU/czcNLDPGESlA5Ue/l9Ck4Yvh8LeM= breadcat"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbQriNUdqa3a1EFH4Al46szdlHon2nrDxwW1jOLuWQ9 breadcat"
              ];

            };

            boot.loader.grub.device = "/dev/disk/by-label/NIXOS_SD";
            fileSystems."/" = {
              device = "/dev/disk/by-label/NIXOS_SD";
              fsType = "ext4";
              options = [ "x-initrd.mount" ];
            };
            deployment = {
              targetHost = "10.0.0.91";
              targetPort = 22;
              targetUser = "breadcat";
            };
          };
      };
    };
}
