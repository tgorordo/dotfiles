{
  description = "Home Manager configuration of tgorordo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations = {
        "you@tensor" = home-manager.lib.homeManagerConfiguration { inherit pkgs; modules = [ ./home.nix ]; };
        "you@vector" = home-manager.lib.homeManagerConfiguration { inherit pkgs; modules = [ ./home.nix ]; };
      };
    };
}
