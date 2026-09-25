{ config, pkgs, inputs, username, ... }:

{
  # ─────────────────────────────────────────────
  # Paquetes de usuario
  # ─────────────────────────────────────────────
  home.packages = with pkgs; [

    ## system
    desktop-file-utils  # update-desktop-database
    file                # comando file

    lm_sensors
    # btop
    btop-rocm
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    rocmPackages.clr
    bat
    ripgrep
    ripgrep-all
    fd
    jq
    tree
    lsd

    baobab
    filezilla

    nnn

    ## archivos comprimidos
    gnutar      # .tar
    gzip        # .gz
    bzip2       # .bz2
    xz          # .xz / .lzma
    unzip       # .zip
    p7zip       # .7z
    unrar       # .rar (no libre, pero disponible en nixpkgs)
    libarchive  # bsdtar, soporta casi todo

    # Frontend gráfico (elige uno)
    xarchiver   # ligero, GTK, recomendado para Hyprland
    file-roller # alternativa GNOME, más pesada
    # engrampa    # alternativa MATE

    # Hyprland ecosystem
    wl-clipboard
    grim
    slurp
    hyprpaper
    pamixer
    brightnessctl
    playerctl      # control de reproductores de audio
    pavucontrol    # control de volumen GUI (para waybar click)
    seahorse

    ## recomendados
    ## imgs
    viewnior
    swayimg

    ## pdf
    zathura
    sioyek

    # Apps
    # ============================================================
    # NAVEGADORES
    # ============================================================
    brave
    vivaldi
    # opera
    # zen-browser
    google-chrome

    # ============================================================
    # MULTIMEDIA / AUDIO
    # ============================================================
    vlc
    mpv
    strawberry
    exaile
    sayonara
    blanket

    easyeffects
    lsp-plugins
    calf
    zam-plugins
    mda_lv2
    qmmp

    # ============================================================
    # OFICINA
    # ============================================================
    obsidian
    onlyoffice-desktopeditors

    # ============================================================
    # GRÁFICOS / ARTE / DISEÑO
    # ============================================================
    blender
    gimp
    inkscape
    krita
    libresprite
    tiled
    milkytracker
    goxel
    pixelorama

    # ============================================================
    # AUDIO PRODUCCIÓN
    # ============================================================
    musescore
    famistudio    # No está en nixpkgs → AppImage
    freac         # No está en nixpkgs → Flatpak/AppImage
    asunder

    # ============================================================
    # EMULADORES
    # ============================================================
    ppsspp          # PSP
    pcsx2           # PS2
    #duckstation     # PS1 # appimage
    #rpcs3         # No está en nixpkgs → AppImage/Flatpak
    dolphin-emu     # GameCube / Wii
    mgba            # GBA
    snes9x          # SNES
    melonds         # NDS
    cemu            # WiiU
    # lime3ds       # 3DS (alternativa a Citra) → verificar o usar AppImage
    flycast         # Dreamcast
    retroarch
    retroarch-assets
    #retroarch-cores
    stella          # Atari 2600

    # ============================================================
    # JUEGOS / PLATAFORMAS
    # ============================================================
    heroic
    protonup-qt
    #lutris
    #wineWow64Packages.staging
    #winetricks
    openra
    #qzdl           # No está en nixpkgs → AppImage
    tic-80

    # ============================================================
    # DESCARGAS / UTILIDADES
    # ============================================================
    # jdownloader   # No está en nixpkgs → Flatpak
    # yt-dlp
    # tartube       # version vieja
    tartube-yt-dlp
    qbittorrent
    qalculate-gtk
    qalculate-qt

    # ============================================================
    # DESARROLLO
    # ============================================================
    tree-sitter
    bash-language-server
    vscode
    #vscode-fhs
    #vscodium
    ## zed-editor, tiene problemas con los entornos, esperar a una nueva version
    # gitfourchette # No está en nixpkgs → Flatpak/AppImage
    gittyup
    #sasm
    sqlitebrowser
    dbeaver-bin
    antares
    # beekeeper-studio  ## insecure
    # godot_4           ## version stable
    nmap ## `ncat`, es para godot

    # ============================================================
    # OTROS (NO ENCONTRADOS EN NIXPKGS)
    # ============================================================
    # ziggity       # No está en nixpkgs → AppImage

    # Otros
    mousepad

    # ============================================================
    # mis paquetes
    # ============================================================
    inputs.godot_next.packages.x86_64-linux.default ## 4.8-dev4
    inputs.beyond_all_reason.packages.x86_64-linux.default
    inputs.zdl.packages.x86_64-linux.default
    inputs.ziggity.packages.x86_64-linux.default
  ];

  ## creo que es para tartube
  # nixpkgs.config.permittedInsecurePackages = [
  #   "python3.14-youtube-dl-2021.12.17"
  # ];

  programs.mpv = {
    enable = true;
    config = {
      volume = 80;
      profile = "gpu-hq";
      scale = "ewa_lanczossharp";
      force-window = "immediate";
      gpu-api = "vulkan";
    };
  };

  ## ~/.local/share/easyeffects/output
  services.easyeffects = {
    enable = true;
  };

  # services.hyprsunset = {
  #   enable = true;
  #
  #   settings = {
  #     # Opcional: limita el brillo máximo para no pasarte
  #     max-gamma = 150;
  #
  #     # NO definimos 'profile' = arranca limpio (gamma 100%, sin filtros)
  #     # y nunca cambia solo por horario
  #
  #     profile = [
  #       {
  #         # Sin 'time' = perfil por defecto
  #         # gamma 1.0 en config file = 100% (valor decimal)
  #         identity = true;
  #         gamma = 1.0;
  #       }
  #       # {
  #       #   time = "07:30";
  #       #   identity = true;
  #       # }
  #       # {
  #       #   time = "21:00";
  #       #   gamma = 0.8;
  #       # }
  #     ];
  #   };
  # };

  ## Flatpacks
  ## flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  ## pkgs
  ## flatpak install flathub com.github.tchx84.Flatseal
  ## flatpak install flathub org.jdownloader.JDownloader
  ## flatpak install flathub org.gitfourchette.gitfourchette

  ## flatpak install flathub -y com.github.tchx84.Flatseal org.jdownloader.JDownloader org.gitfourchette.gitfourchette app.zen_browser.zen com.opera.Opera us.zoom.Zoom org.telegram.desktop net.rpcs3.RPCS3 org.duckstation.DuckStation io.github.lime3ds.Lime3DS org.citra_emu.citra dev.eden_emu.eden


## despues o ya existen en nixos y no los he probado
## flatpak install flathub net.rpcs3.RPCS3
## flatpak install flathub org.freac.freac
## flatpak install flathub com.github.BleuBleu.FamiStudio
## flatpak install flathub com.github.tartube.Tartube
##
  ## flatpak install flathub org.azahar_emu.Azahar

}
