{ config, pkgs, lib, username, ... }:

{
  # ─────────────────────────────────────────────
  # GTK Theme (Inkscape y apps GTK usan esto)
  # ─────────────────────────────────────────────
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = { enable = true; };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_QPA_PLATFORM = "wayland";
    # CRUCIAL PARA INKSCAPE: Fuerza el uso del selector de archivos nativo
    GTK_USE_PORTAL = "1";
  };

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=adwaita-dark
    icon_theme=Papirus-Dark
    standard_dialogs=xdgportal
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=adwaita-dark
    icon_theme=Papirus-Dark
    standard_dialogs=xdgportal
  '';

  home.packages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qt5ct

    # Temas y decoraciones Qt
    adwaita-qt6   # Tema para Qt6
    adwaita-qt    # Tema para Qt5
    qadwaitadecorations-qt6
    
    # Iconos y GTK (CRUCIAL PARA INKSCAPE)
    papirus-icon-theme
    hicolor-icon-theme        # Fallback obligatorio para que Inkscape no tenga iconos rotos
    gnome-themes-extra
    
    adw-gtk3
    gsettings-desktop-schemas
    gtk3
    gtk4
    
    # Portales XDG para Wayland
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # --- IMÁGENES (Viewnior) ---
        "image/jpeg"                    = [ "viewnior.desktop" ];
        "image/png"                     = [ "viewnior.desktop" ];
        "image/gif"                     = [ "viewnior.desktop" ];
        "image/webp"                    = [ "viewnior.desktop" ];
        "image/bmp"                     = [ "viewnior.desktop" ];
        "image/tiff"                    = [ "viewnior.desktop" ];
        "image/svg+xml"                 = [ "viewnior.desktop" ];
        "image/x-tga"                   = [ "viewnior.desktop" ];
        "image/vnd.adobe.photoshop"     = [ "viewnior.desktop" ]; # Archivos PSD básicos
        "image/vnd.microsoft.icon"      = [ "viewnior.desktop" ]; # Archivos .ico

        # --- DOCUMENTOS PDF (Zathura) ---
        "application/pdf"               = [ "org.pwmt.zathura.desktop" ];
        "application/oxps"              = [ "org.pwmt.zathura.desktop" ];
        "application/epub+zip"          = [ "org.pwmt.zathura.desktop" ]; # Si tienes zathura-pdf-mupdf/epub

        # --- VIDEO Y AUDIO (MPV) ---
        # Videos
        "video/mp4"                     = [ "mpv.desktop" ];
        "video/x-matroska"              = [ "mpv.desktop" ]; # Archivos MKV
        "video/webm"                    = [ "mpv.desktop" ];
        "video/quicktime"               = [ "mpv.desktop" ]; # Archivos MOV
        "video/x-msvideo"               = [ "mpv.desktop" ]; # Archivos AVI
        "video/x-flv"                   = [ "mpv.desktop" ];
        "video/mpeg"                    = [ "mpv.desktop" ];
        "video/ogg"                     = [ "mpv.desktop" ];
        # Audio
        "audio/mpeg"                    = [ "mpv.desktop" ]; # Archivos MP3
        "audio/flac"                    = [ "mpv.desktop" ];
        "audio/ogg"                     = [ "mpv.desktop" ];
        "audio/mp4"                     = [ "mpv.desktop" ];
        "audio/wav"                     = [ "mpv.desktop" ];
        "audio/x-matroska"              = [ "mpv.desktop" ]; # Audio MKA

        # --- TORRENTS (qBittorrent) ---
        "application/x-bittorrent"      = [ "org.qbittorrent.qBittorrent.desktop" ];
        "x-scheme-handler/magnet"       = [ "org.qbittorrent.qBittorrent.desktop" ]; # Enlaces Magnet de navegadores
      };
    }; ## mimeApps

  }; ## xdg
}


## ============================
## segunda idea, aun no la uso
# { config, pkgs, lib, username, ... }:
#
# {
#   # ─────────────────────────────────────────────
#   # GTK Theme (Adwaita dark nativo)
#   # ─────────────────────────────────────────────
#   gtk = {
#     enable = true;
#     colorScheme = "dark";
#     theme = {
#       name = "adw-gtk3-dark";
#       package = pkgs.adw-gtk3;
#     };
#     iconTheme = {
#       name = "Papirus-Dark";
#       package = pkgs.papirus-icon-theme;
#     };
#   };
#
#   # ─────────────────────────────────────────────
#   # Qt Theme - Opción A: Adwaita (coherente con GTK)
#   # ─────────────────────────────────────────────
#   qt = {
#     enable = true;
#     platformTheme.name = "gnome";  # Usa qgnomeplatform
#     style.name = "adwaita-dark";
#   };
#
#   # ─────────────────────────────────────────────
#   # Cursor
#   # ─────────────────────────────────────────────
#   home.pointerCursor = {
#     enable = true;
#     package = pkgs.bibata-cursors;
#     name = "Bibata-Modern-Classic";
#     size = 16;
#     gtk.enable = true;
#     x11.enable = true;
#   };
#
#   # ─────────────────────────────────────────────
#   # Dconf
#   # ─────────────────────────────────────────────
#   dconf.settings = {
#     "org/gnome/desktop/interface" = {
#       color-scheme = "prefer-dark";
#       cursor-theme = "Bibata-Modern-Classic";
#     };
#   };
#
#   # ─────────────────────────────────────────────
#   # Variables de entorno
#   # ─────────────────────────────────────────────
#   home.sessionVariables = {
#     XDG_CURRENT_DESKTOP = "Hyprland";
#     QT_QPA_PLATFORM = "wayland";
#   };
#
#   home.packages = with pkgs; [
#     # ── Qt platform & theming ──
#     qgnomeplatform
#     qgnomeplatform-qt6
#     adwaita-qt
#
#     # ── Iconos (también usados por Qt vía qgnomeplatform) ──
#     papirus-icon-theme
#
#     # ── GTK theming ──
#     adw-gtk3
#     gsettings-desktop-schemas
#     gtk3
#   ];
#
#   # ─────────────────────────────────────────────
#   # XDG
#   # ─────────────────────────────────────────────
#   xdg = {
#     enable = true;
#     userDirs = {
#       enable = true;
#       createDirectories = true;
#       setSessionVariables = true;
#     };
#   };
# }

## ============================
## En el caso de querer usar kvantum
## kvantum
  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  #   style.name = "kvantum";
  # };
  #
  # home.packages = with pkgs; [
  #   libsForQt5.qtstyleplugin-kvantum
  #   qt6Packages.qtstyleplugin-kvantum
  #   (catppuccin-kvantum.override {
  #     accent = "Blue";
  #     variant = "Mocha";
  #   })
  #   libsForQt5.qt5ct
  #   qt6Packages.qt6ct
  #   papirus-icon-theme
  # ];
  #
  # xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
  #   [General]
  #   theme=Catppuccin-Mocha-Blue
  # '';
  #
  # xdg.configFile."qt5ct/qt5ct.conf".text = ''
  #   [Appearance]
  #   icon_theme=Papirus-Dark
  #   style=kvantum
  # '';
  #
  # xdg.configFile."qt6ct/qt6ct.conf".text = ''
  #   [Appearance]
  #   icon_theme=Papirus-Dark
  #   style=kvantum
  # '';
