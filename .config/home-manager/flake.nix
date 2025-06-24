{
  description = "Home Manager configuration of Ilya";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-system-graphics = {
    #   url = "github:soupglasses/nix-system-graphics";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."ilya" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      # systemConfigs.default = system-manager.lib.makeSystemConfig {
      #   modules = [
      #     nix-system-graphics.systemModules.default
      #     ({
      #       config = {
      #         nixpkgs.hostPlatform = "x86_64-linux";
      #         system-manager.allowAnyDistro = true;
      #         system-graphics.enable = true;
      #       };
      #     })
      #   ];
      # };
    };
}
