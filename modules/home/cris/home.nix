{ config, pkgs, inputs, username, ... }:

{
  home.username = "cris";
  home.homeDirectory = "/home/cris";
  home.stateVersion = "26.05";

  ## para UWSM 
  wayland.windowManager.hyprland.systemd.enable = false;


#  home.sessionPath = [
#    "$HOME/.local/bin"
#  ];

  ## polkit version home, ya tengo esto
  ## en su version `configuration.nix``
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   Unit = {
  #     Description = "polkit-gnome-authentication-agent-1";
  #     Wants = [ "graphical-session.target" ];
  #     After = [ "graphical-session.target" ];
  #   };
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  # services.gnome-keyring = {
  #   enable = true;
  #   components = [ "pkcs11" "secrets" "ssh" ];
  # };

  # systemd.user.services.gnome-keyring-ssh = {
  #   Unit = {
  #     Description = "GNOME Keyring daemon (ssh + secrets + pkcs11 components)";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh";
  #     Restart = "on-failure";
  #   };
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    #SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    #SSH_AUTH_SOCK = "\$XDG_RUNTIME_DIR/keyring/ssh"; # Asegúrate de escapar el '$' con '\'
    SSH_AUTH_SOCK = "\$XDG_RUNTIME_DIR/gcr/ssh"; 
  };

  # services.ssh-agent.enable = true;
  #
  # programs.ssh = {
  #   enable = true;
  #
  #   # Soluciona la tercera advertencia: Desactiva los valores por defecto antiguos
  #   enableDefaultConfig = false;
  #
  #   # Soluciona la primera y segunda advertencia usando la nueva estructura 'settings'
  #   settings = {
  #     "*" = {
  #       AddKeysToAgent = "yes";
  #       IdentityFile = "~/.ssh/id_ed25519";
  #
  #       # Al desactivar 'enableDefaultConfig', se recomienda mantener estos valores básicos manuales:
  #       ForwardAgent = "no";
  #       Compression = "no";
  #       ServerAliveInterval = "0";
  #       ServerAliveCountMax = "3";
  #       HashKnownHosts = "no";
  #       UserKnownHostsFile = "~/.ssh/known_hosts";
  #       ControlMaster = "no";
  #     };
  #   };
  # };


  imports = [
    ## home
    ./pkgs.nix
    ./environment.nix
    ./user.nix
    ./terminales.nix
    ./nvim/nvim.nix

    ./noctalia.nix
    ./hyprland.nix
    ./services.nix
  ];

  #programs.home-manager.enable = true;

}
