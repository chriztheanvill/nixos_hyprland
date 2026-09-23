{ config, pkgs, lib, username, ... }:

{
  # ─────────────────────────────────────────────
  # GTK Theme (Adwaita dark nativo)
  # ─────────────────────────────────────────────
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      # name = "Qogir-dark";       # o "Qogir"
      # package = pkgs.qogir-icon-theme;
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };

  # ─────────────────────────────────────────────
  # Qt Theme (Breeze Dark vía qt6ct)
  # ─────────────────────────────────────────────
   qt = { ## incompleto
     enable = true;
     platformTheme.name = "adwaita";  
     style.name = "adwaita-dark";
   };
  # qt = { ## ESTE SI FUNCIONA < ===============
  #   enable = true;
  #   platformTheme.name = "gnome";       # <- ESTO es lo que fuerza a Qt a leer la config de GTK
  #   style.name = "adwaita-dark";       # Fallback visual si algo no carga por GTK
  #   style.package = pkgs.adwaita-qt;   # Asegura que el estilo base esté disponible
  # };
  # qt = { ## ESTE SI FUNCIONA < ===============
  #   enable = true;
  #   platformTheme.name = "gtk3";       # <- ESTO es lo que fuerza a Qt a leer la config de GTK
  #   style.name = "adwaita-dark";       # Fallback visual si algo no carga por GTK
  #   style.package = pkgs.adwaita-qt;   # Asegura que el estilo base esté disponible
  # };
#   qt = {
#     enable = true;
#     platformTheme.name = "gtk3";   # QGtk3Style: usa el tema GTK3 activo
# #style.name = "adwaita-dark";
#   };
#  qt = {
#    enable = true;
#    platformTheme.name = "kde";   # <- Más estable que "kde" sin Plasma
#    style.name = "breeze";
#  };

# qt = {
#     enable = true;
#     platformTheme.name = "kvantum";
#     style.name = "kvantum";
#   };

#home.file.".config/kdeglobals" = {
#    text = ''
#      ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
#    '';
#  };

  # Configuración automática de qt6ct (para no tener que abrir la GUI)
  # xdg.configFile."qt6ct/qt6ct.conf".text = lib.mkForce ''
  #   [Appearance]
  #   standard_dialogs=default
  #   style=Breeze
  #   icon_theme=Papirus-Dark
  # '';

  # ─────────────────────────────────────────────
  # Cursor
  # ─────────────────────────────────────────────
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  # ─────────────────────────────────────────────
  # Dconf (tema oscuro global para apps GTK4/GNOME)
  # ─────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
#gtk-theme = "adw-gtk3-dark"; ## este
      # icon-theme = "Qogir-dark"; ## este
      # icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };

  # ─────────────────────────────────────────────
  # Variables de entorno
  # ─────────────────────────────────────────────
  home.sessionVariables = {
    #GTK_THEME = "adw-gtk3-dark"; ## este <===================
#QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
#QT_QPA_PLATFORMTHEME = "gtk3";
#GTK_USE_PORTAL = "1";
    #QT_WAYLAND_DECORATION = "adwaita";
#QT_WAYLAND_DECORATION = "gtk3";
#QT_STYLE_OVERRIDE = "gtk3";
    XDG_CURRENT_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland";
  };

  home.packages = with pkgs; [
    # qt6Packages.qt6ct ## funciona
    qgnomeplatform
    qgnomeplatform-qt6   # Plugin para Qt6 ## funciona

    adwaita-qt
    adw-gtk3
    qadwaitadecorations-qt6
    gsettings-desktop-schemas
    gtk3

    # papirus-icon-theme
    # hicolor-icon-theme    # fallback estándar, mejora cobertura
    # kdePackages.breeze-icons  # ya lo tienes — bien, esto ayuda a Qt
    # kdePackages.breeze          # Tema Breeze para Qt6 ## funciona
    # kdePackages.breeze-icons    # Iconos Breeze (fallback) ## funciona
  ];


  # ─────────────────────────────────────────────
  # XDG
  # ─────────────────────────────────────────────
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };

}
