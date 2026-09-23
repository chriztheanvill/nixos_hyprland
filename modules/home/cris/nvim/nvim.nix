{ config, pkgs, ... }:

{
#programs.neovim.enable = true;

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  home.packages = with pkgs; [
    tree-sitter   # ← El CLI que falta
      gcc           # ← Para compilar los parsers
      gnumake       # ← Algunos parsers lo usan
      marksman
    lua-language-server
    nil
  ];
}
