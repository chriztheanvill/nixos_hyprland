{
  description = "NixOS + Hyprland + Home Manager (unido)";

  ## para evitar que nix compile `noctalia`
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      #url = "github:noctalia-dev/noctalia";
      url = "github:noctalia-dev/noctalia/cachix";
      ## evitar que compile
      ##inputs.nixpkgs.follows = "nixpkgs";
    };

    ## mis flakes
    godot_next = {
      url = "path:/home/cris/Workspace/build_pkgs/godot_next";
      # Si tu flake de Godot tiene nixpkgs como input, descomentá esto:
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beyond_all_reason = {
      url = "path:/home/cris/Workspace/build_pkgs/beyond_all_reason";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zdl ={
      url = "path:/home/cris/Workspace/build_pkgs/zdl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ziggity ={
      url = "path:/home/cris/Workspace/build_pkgs/ziggity";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./modules/hosts/nixos
      ];
    };
}
## There are 404 unread and relevant news items.
## Read them by running the command "home-manager news".

