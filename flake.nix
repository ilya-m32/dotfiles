{
  description = "Home Manager configuration of Ilya";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      packagePins = builtins.fromJSON (builtins.readFile ./package-pins.json);
      pinnedPackagesOverlay = final: prev:
        nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate { } (
          nixpkgs.lib.mapAttrsToList (
            name: pin:
            let
              attrPath = nixpkgs.lib.splitString "." (pin.attrPath or name);
              pinnedPkgs = (builtins.getFlake "github:NixOS/nixpkgs/${pin.rev}").legacyPackages.${system};
              package = nixpkgs.lib.attrByPath attrPath (throw "Pinned package ${name} not found") pinnedPkgs;
            in
            assert package.version == pin.version;
            nixpkgs.lib.setAttrByPath attrPath package
          ) packagePins
        );
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ pinnedPackagesOverlay ];
      };
      guiEnabled = true;
      withCorpoStuff = false;
      withRust = false;
      user = "ilya";
    in
    {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          guiEnabled = guiEnabled;
          user = user;
          withCorpoStuff = withCorpoStuff;
          withRust = withRust;
        };

        modules = [ ./home.nix ];
      };
    };
}
