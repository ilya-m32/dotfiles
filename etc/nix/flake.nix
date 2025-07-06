{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, system-manager, nix-system-graphics }: {
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        nix-system-graphics.systemModules.default
        ({
          config = {
            nixpkgs.hostPlatform = "x86_64-linux";
            system-manager.allowAnyDistro = true;
            system-graphics.enable = true;
          };
        })
      ];
    };
  };
}
