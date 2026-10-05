{
  description = "Home Manager configuration of tgorordo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { nixpkgs, home-manager, llm-agents, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations = {
        "tgorordo@tensor" = home-manager.lib.homeManagerConfiguration { inherit pkgs; extraSpecialArgs = { inherit inputs; }; modules = [ ./home.nix ]; };
        "tgorordo@vector" = home-manager.lib.homeManagerConfiguration { inherit pkgs; extraSpecialArgs = { inherit inputs; }; modules = [ ./home.nix ]; };
      };
    };
}
