{
  description = "Home Manager configuration of tgorordo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    nixpkgs-zotero.url = "github:NixOS/nixpkgs/7a0f122f5090cf4c2ade2a13a0e229d4e19ba71f";

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
