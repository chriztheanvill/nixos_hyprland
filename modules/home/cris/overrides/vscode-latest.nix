{ pkgs, ... }:

pkgs.vscode.overrideAttrs (old: rec {
  version = "1.139.0";
  src = pkgs.fetchurl {
    name = "VSCode_${version}_linux-x64.tar.gz";
    url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
    ## generar sha:
    ## `nix store prefetch-file --hash-type sha256 https://update.code.visualstudio.com/1.139.0/linux-x64/stable`
    hash = "sha256-7xhGHRTWWCVZF+qXjNzLIFdveXr42fYGLmrFr6n17FE=";
  };
})
