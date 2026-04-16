{
  description = "dogeOnNix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-mine.url = "github:dogethebeast/nixpkgs/autoswitch-virtualenv-init";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, nixpkgs-mine }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    pkgsUnstable = import nixpkgs-unstable { inherit system; };
		pkgsMine = import nixpkgs-mine {inherit system; };
  in {
    nixosConfigurations.dogeOnNix = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
	stylix.nixosModules.stylix
	home-manager.nixosModules.home-manager
        {
          home-manager.users.doge = ./home.nix;
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.extraSpecialArgs = {
            inherit pkgsUnstable;
						inherit pkgsMine;
          };
        }
      ];
    };
  };
}
