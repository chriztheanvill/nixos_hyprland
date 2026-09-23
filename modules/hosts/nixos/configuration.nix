# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system/boot.nix
      ./system/gpu.nix
      ./system/audio.nix
      ./system/file_systems.nix
      ./system/gaming.nix
      ./system/virtual.nix
      ./system/noctalia.nix
    ];

  # ─────────────────────────────────────────────
  # Nix
  # ─────────────────────────────────────────────
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  # ─────────────────────────────────────────────
  # Red / Hostname
  # ─────────────────────────────────────────────
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.useDHCP = lib.mkDefault true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Bluetooth
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  # SSH
  services.openssh.enable = true;

  # ─────────────────────────────────────────────
  # Locale / Time
  # ─────────────────────────────────────────────
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  # ─────────────────────────────────────────────
  # X11 / Teclado / Display Manager
  # ─────────────────────────────────────────────
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      #options = "ctrl:nocaps";
    };
    videoDrivers = [ "amdgpu" ];
  };
  console.useXkbConfig = true;
  services.displayManager.defaultSession = "hyprland";

  # ─────────────────────────────────────────────
  # Usuario
  # ─────────────────────────────────────────────
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."cris" = {
    isNormalUser = true;
    description = "cris";
    	shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "gamemode" "input" "i2c" "libvirtd"];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  # ─────────────────────────────────────────────
  # HOME MANAGER COMO MÓDULO DE NIXOS
  # ─────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs = true;      # Usa la misma instancia de nixpkgs que el sistema
    useUserPackages = true;    # Instala paquetes como si fueran del sistema (más limpio)
    backupFileExtension = "backup";  # Renombra archivos existentes en vez de fallar

    extraSpecialArgs = { inherit inputs username; };

    users.${username} = import ../../home/cris/home.nix;
  };

  # ─────────────────────────────────────────────
  # Zsh (solo habilitar a nivel sistema)
  # ─────────────────────────────────────────────
  programs.zsh.enable = true;

  # ─────────────────────────────────────────────
  # Hyprland (sesión del sistema)
  # ─────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  ## lock
  security.pam.services.hyprlock = {};

  # ─────────────────────────────────────────────
  # Variables de entorno globales
  # ─────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # QT_QPA_PLATFORM = "wayland;xcb";
    # QT_QPA_PLATFORMTHEME = "gtk2";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # ─────────────────────────────────────────────
  # XDG Portal (escencial para Flatpak, screenshare, etc.)
  # ─────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.hyprland
    ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
    config.common = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };

  # ─────────────────────────────────────────────
  # Thunar + montaje automático
  # ─────────────────────────────────────────────
  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };

  services.gvfs.enable = true;
  services.devmon.enable = true;
  programs.dconf.enable = true;
  #programs.xfconf.enable = true;

  # ─────────────────────────────────────────────
  # Flatpak
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # ─────────────────────────────────────────────
  services.flatpak.enable = true;
  security.polkit.enable = true;

  # ─────────────────────────────────────────────
  # Fuentes
  # ─────────────────────────────────────────────
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    noto-fonts
    liberation_ttf
    dina-font
    proggyfonts
    google-fonts
    fira
    fira-mono
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.sauce-code-pro
    # nerd-fonts.sauce-code-pro
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  # ─────────────────────────────────────────────
  # DM
  # ─────────────────────────────────────────────
## greeted
## problemas con los temas
## incompatible con dos monitores

  ## GDM
  # services.displayManager.gdm.enable = true;

  ## lightdm
#  services.xserver = {
#    displayManager.lightdm = {
#      enable = true;
#      greeters.slick.enable = true;  # o .mini, .gtk, .tiny
#    };
#  };

#   services.displayManager.sddm = {
#    enable = true;
#
#    wayland = {
#      enable = true;
#      # Opcional: cambia el compositor (default: weston)
#      # compositor = "kwin";
#    };
#
#    # Tema Qt (ejemplo con un tema oscuro)
#    theme = "breeze";
#
#    # O un tema personalizado:
#    # theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut";
#  };

  ## TUI greet
  #  services.greetd = {
  #    enable = true;
  #    settings = {
  #      default_session = {
  #        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start select' --remember --remember-user-session --user-menu --asterisks";
  #        user = "greeter";
  #      };
  #    };
  #  };

  ## greetd + regreet
  #  services.greetd = {
  #    enable = true;
  #    settings = {
  #      default_session = {
  #        command = "${pkgs.greetd.regreet}/bin/regreet";
  #        user = "greeter";
  #      };
  #    };
  #  };
  #
  #  programs.regreet = {
  #    enable = true;
  #    settings = {
  #      # Personaliza aquí: fondo, tema, etc.
  #    };
  #  };

  ## Ly
  services.displayManager.ly = {
    enable = true;
  };

  programs.xwayland.enable = true;

  # ─────────────────────────────────────────────
  # Servicios del sistema
  # ─────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.dbus.enable = true;
#services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

   #security.pam.services.lightdm.enableGnomeKeyring = true;

 #  security.pam.services.sddm.enableGnomeKeyring = true;
   #security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.gdm.enableGnomeKeyring = true;
  # security.pam.services.gdm-password.enableGnomeKeyring = true;

  # ─────────────────────────────────────────────
  # Paquetes del sistema (mínimos)
  # ─────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  ## habilita ~/.local/bin
  environment.localBinInPath = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    xdg-utils
    mesa-demos
    vulkan-tools
    libva-utils
    home-manager

    amdgpu_top

    ## wayland
    xwayland-satellite

    ## gnome
    polkit_gnome

    ##
    ddcutil # brillo monitor desktop
    hyprsunset

    brightnessctl
  ];

  # AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # ─────────────────────────────────────────────
  # Develop
  # ─────────────────────────────────────────────
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # ─────────────────────────────────────────────
  # State / Updates
  # ─────────────────────────────────────────────

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  # services.displayManager.defaultSession = "hyprland";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
