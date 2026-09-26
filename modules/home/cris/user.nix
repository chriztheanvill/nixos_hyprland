{ config, pkgs, username, ... }:

{
  # ─────────────────────────────────────────────
  # Git
  # ─────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "chriztheanvill";
        email = "chriztheanvill@gmail.com";
      };
      core.editor = "nvim";
    };
  };

  # ─────────────────────────────────────────────
  # FZF
  # ─────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ─────────────────────────────────────────────
  # Zsh (configuración completa del usuario)
  # ─────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = config.home.homeDirectory;
    oh-my-zsh = {
      enable = true;
      theme = "candy";
      # theme = "jonathan";
      plugins = [ "git" "sudo" "history" "fzf" ];
    };

    shellAliases = {
      ## para instalar paquetes
      rebuild = "sudo nixos-rebuild switch --flake ~/.nixos-config#nixos";
      # rebuild_home = "home-manager switch --flake ~/.nixos-config#cris"; ## muy viejo
      # rebuild_home_b = "home-manager switch --flake ~/.nixos-config#cris -b backup";

      ## actualizar
      ## como apt-update
      update_ref  = "sudo nix flake update --flake ~/.nixos-config"; 

      ## apt apt-upgrade
      ## update_upgrade  = "sudo nixos-rebuild switch --flake ~/.nixos-config#nixos --upgrade";

      ## apt dist-upgrade
      update_dist  = "sudo nix flake update --flake ~/.nixos-config && sudo nixos-rebuild switch --flake ~/.nixos-config#nixos && nix profile diff-closures --profile /nix/var/nix/profiles/system";

      ## build, solo compila, es para probar si todo va bien
      update_test = "sudo nixos-rebuild build --flake ~/.nixos-config#nixos --print-build-logs";

      # Abre Neovim para que escribas el mensaje del commit, al guardar y salir, aplica los cambios.
      save_rebuild_enter = "cd ~/.nixos-config && git add . && git commit && sudo nixos-rebuild switch --flake .#nixos";

      save_rebuild = ''
        cd ~/.nixos-config && git add . && git commit -m "chore(flake): update inputs $(date '+%Y-%m-%d %H:%M')" && sudo nixos-rebuild switch --flake .#nixos
        '';

      save_update_rebuild = ''
        cd ~/.nixos-config && sudo nix flake update && git add . && git commit -m "chore(flake): update inputs $(date '+%Y-%m-%d %H:%M')" && sudo nixos-rebuild switch --flake .#nixos && nix profile diff-closures --profile /nix/var/nix/profiles/system
        '';

      # Actualiza dependencias y hace un commit automático del flake.lock con la fecha de hoy.
      save_update_ref = ''
        cd ~/.nixos-config && sudo nix flake update && git add flake.lock && git commit -m "chore(flake): update inputs $(date +%Y-%m-%d %H:%M)"
        '';

      # Sincroniza tu configuración a la nube (GitHub/GitLab).
      sync-update = "cd ~/.nixos-config && git push";

      clean = "sudo nix-collect-garbage -d";
      ll = "lsd -la --group-dirs first";
      v = "nvim";
      cv = "clear && nvim";
      n = "nnn";
      cn = "clear && nnn";
      z = "ziggity";
    };
  };
}
