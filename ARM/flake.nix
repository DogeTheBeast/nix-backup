{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, apple-silicon-support, nixpkgs-unstable, stylix, nixvim, nur }:
  let
    system = "aarch64-linux";
    pkgs = import nixpkgs { inherit system; };
    pkgsUnstable = import nixpkgs-unstable { inherit system; };
  in {
    nixosConfigurations.dogeOnArm = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
	apple-silicon-support.nixosModules.apple-silicon-support
	stylix.nixosModules.stylix
	nur.modules.nixos.default
	home-manager.nixosModules.home-manager {
	  home-manager.users.doge.imports = [
	    ./home.nix
	    nixvim.homeModules.nixvim
	  ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	  home-manager.extraSpecialArgs = {
	    inherit pkgsUnstable;
	  };
	}
      ];
    };
  };
}
