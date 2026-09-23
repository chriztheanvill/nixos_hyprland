{ config, pkgs, inputs, username, ... }:

{
  home.username = "cris";
  home.homeDirectory = "/home/cris";
  home.stateVersion = "26.05";

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

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  imports = [
    ## home
    ./environment.nix
    ./hyprland.nix
    ./noctalia.nix
    ./pkgs.nix
    ./terminales.nix
    ./user.nix

    ## nvim
    ./nvim/nvim.nix
  ];

  #programs.home-manager.enable = true;

}
