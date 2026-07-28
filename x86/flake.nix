{
  description = "dogeOnNix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi.url = "github:lukasl-dev/pi.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stylix,
      sops-nix,
      nixvim,
      nur,
      pi,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixosConfigurations.dogeOnNix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          stylix.nixosModules.stylix
          nur.modules.nixos.default
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.users.doge.imports = [
              nixvim.homeModules.nixvim
              pi.homeModules.default
              ./home.nix
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
