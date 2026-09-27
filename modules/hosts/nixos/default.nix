{ self, inputs, ... }:
let
  username = "cris";
  hostname = "nixos";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs username; };
    modules = [
      { nixpkgs.overlays = [ (import ../../overlays/vscode-latest.nix) ]; }
      ./configuration.nix
      inputs.home-manager.nixosModules.default   # ← Importante
    ];
  };
}
