{ config, pkgs, ... }:

{
   # ─────────────────────────────────────────────
  # Hyprland (configuración del usuario)
  # ─────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";

    extraConfig = ''
      -- ============================================
      -- MONITOR
      -- ============================================
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      -- ============================================
      -- ENVIRONMENT
      -- ============================================
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")
      -- Indica a Qt que use qt6ct para manejar los temas
      -- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

      -- ============================================
      -- PROGRAMS
      -- ============================================
      local terminal    = "kitty"
      local fileManager = "thunar ~/Downloads"
      local menu        = "wofi --show drun"
      local browser     = "brave"

      -- ============================================
      -- AUTOSTART
      -- ============================================
      hl.on("hyprland.start", function()
         -- Configura el modo oscuro para aplicaciones GTK al iniciar
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'") -- Cambia 'Adwaita-dark' por tu tema
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'") -- Cambia 'Adwaita-dark' por tu tema
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

        -- pkgs autostart
        hl.exec_cmd("waybar")
        hl.exec_cmd("mako")
        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")
        hl.exec_cmd("/home/cris/.nix-profile/bin/qmmp")

      end)

      -- ============================================
      -- CONFIGURACION GENERAL
      -- ============================================
      hl.config({
        general = {
          gaps_in  = 5,
          gaps_out = 10,
          border_size = 2,
          col = {
            active_border   = { colors = {"rgba(89b4faff)", "rgba(b4befeff)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
          },
          layout = "dwindle",
        },

        decoration = {
          rounding = 10,
          blur = { enabled = true },
          shadow = { enabled = true },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true,
        },

        input = {
          kb_layout = "us",
	  kb_options = "ctrl:nocaps",  -- ← ESTO es lo que necesita Hyprland
          follow_mouse = 1,
          touchpad = {
            natural_scroll = false,
          },
        },

        misc = {
          force_default_wallpaper = -1,
          disable_hyprland_logo = false,
        },
      })

      -- ============================================
      -- CURVES (bezier)
      -- ============================================
      hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

      -- ============================================
      -- ANIMATIONS
      -- ============================================
      hl.animation({ leaf = "windows",       enabled = true, speed = 7,  bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut",    enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
      hl.animation({ leaf = "border",        enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "borderangle",   enabled = true, speed = 8,  bezier = "default" })
      hl.animation({ leaf = "fade",          enabled = true, speed = 7,  bezier = "default" })
      hl.animation({ leaf = "workspaces",    enabled = true, speed = 6,  bezier = "default" })

      -- ============================================
      -- KEYBINDINGS
      -- ============================================
      local mod = "SUPER"

      -- Basics
      hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + M", hl.dsp.exit())
      hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(menu))
      hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("wofi --show run"))
      hl.bind(mod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
      hl.bind(mod .. " + Y", hl.dsp.layout("togglesplit"))
      hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
      hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
      -- hl.bind(mod .. " + Z", hl.dsp.exec_cmd("wlogout"))
      hl.bind(mod .. " + W", hl.dsp.exec_cmd("hyprlock"))

      hl.bind(mod .. " + Z", hl.dsp.exec_cmd([[bash -c 'opt=$(printf "🔒  Lock\n🚪  Logout\n⏻  Shutdown\n🔄  Reboot" | wofi --dmenu --prompt "Power Menu" --width 300 --height 250); case "$opt" in *Lock) loginctl lock-session ;; *Logout) hyprctl dispatch exit ;; *Shutdown) systemctl poweroff ;; *Reboot) systemctl reboot ;; esac']]))

      -- Focus - flechas
      -- hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "l" }))
      -- hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
      -- hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "u" }))
      -- hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "d" }))

      -- Focus (hjkl)
      hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
      hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
      hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
      hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

      -- Mover ventanas (swap)
      hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
      hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
      hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
      hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

      -- Resize ventanas (Super + Alt + hjkl)
      local resize_amount = 50 -- Ajusta este número para cambiar la velocidad/píxeles del redimensionado

      hl.bind(mod .. " + ALT + H", hl.dsp.window.resize({ x = -resize_amount, y = 0, relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = resize_amount, relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -resize_amount, relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + L", hl.dsp.window.resize({ x = resize_amount, y = 0, relative = true }), { repeating = true })

      -- Mover tile
      hl.bind(mod .. " + CTRL + H", hl.dsp.window.move({ direction = "l" }))
      hl.bind(mod .. " + CTRL + J", hl.dsp.window.move({ direction = "d" }))
      hl.bind(mod .. " + CTRL + K", hl.dsp.window.move({ direction = "u" }))
      hl.bind(mod .. " + CTRL + L", hl.dsp.window.move({ direction = "r" }))

      -- Centrar ventana flotante
      hl.bind(mod .. " + C", hl.dsp.window.center())

      -- Fullscreen
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

      -- Workspaces
      for i = 1, 10 do
        local key = i % 10
        hl.bind(mod .. " + " .. key,       hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Mouse
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

      -- Media keys
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"))
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pamixer --default-source -t"))

      -- Brillo de pantalla, solo laptops
      -- hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"))
      -- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

      -- Brillo vía hyprsunset (gamma, NO usar decimales)
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"))

      -- Reset de emergencia (por si se queda en negro otra vez)
      hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("hyprctl hyprsunset reset gamma"))

      -- ============================================
      -- WINDOW RULES
      -- ============================================
      hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
      hl.window_rule({ match = { class = "pavucontrol" }, float = true })

      -- Pavucontrol: float + centrado + tamaño fijo
      hl.window_rule({ match = { class = "pavucontrol" }, float = true, center = true, size = {800, 600} })
      hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, center = true, size = {800, 600} })

      -- Steam y todo lo relacionado: siempre float
      hl.window_rule({ match = { class = "steam" }, float = true, center = true, size = {1200, 800} })
      hl.window_rule({ match = { class = "steamwebhelper" }, float = true, center = true, size = {1000, 700} })
    '';
  };

  # ─────────────────────────────────────────────
  # Waybar
  # ─────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = ["HDMI-A-1"]; ## usar `hyprctl monitors`, para ver el nombre del monitor
        spacing = 4;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = ["mpris" "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true; ## muestra workspaces de todos los monitores
        };
        "hyprland/window" = {
          # ── Versión A: Icono nativo + texto reducido ─────────────────────
          format = "{class} — {title}";
          icon = true;
          icon-size = 16;
          max-length = 60;
          separate-outputs = true;   # útil si usas varios monitores

          rewrite = {
            # === Regla general: título que es PURAMENTE un path ===
            # /home/user/project/main.rs  →  project/main.rs
            ".*/([^/]+)/([^/]+)$" = "$1/$2";

            # === Neovim / Vim ===
            # path con sufijo - NVIM
            ".*/([^/]+)/([^/]+) - NVIM" = "$1/$2";
            # cualquier otro título con sufijo - NVIM
            "(.*) - NVIM" = "$1";
            ".*/([^/]+)/([^/]+) - Vim" = "$1/$2";
            "(.*) - Vim" = "$1";

            # === VS Code / Codium / OSS ===
            ".*/([^/]+)/([^/]+) - Visual Studio Code" = "$1/$2";
            "(.*) - Visual Studio Code" = "$1";
            ".*/([^/]+)/([^/]+) - VSCodium" = "$1/$2";
            "(.*) - VSCodium" = "$1";
            ".*/([^/]+)/([^/]+) - Code" = "$1/$2";
            "(.*) - Code" = "$1";
            ".*/([^/]+)/([^/]+) - Code - OSS" = "$1/$2";
            "(.*) - Code - OSS" = "$1";

            # === Navegadores (quitar sufijo; el título de página no suele ser path) ===
            "(.*) - Mozilla Firefox" = "$1";
            "(.*) - Chromium" = "$1";
            "(.*) - Google Chrome" = "$1";
            "(.*) - Brave" = "$1";
            "(.*) - LibreWolf" = "$1";
            "(.*) - qutebrowser" = "$1";
            "(.*) - Microsoft Edge" = "$1";

            # === Gestores de archivos ===
            ".*/([^/]+)/([^/]+) - Thunar" = "$1/$2";
            "(.*) - Thunar" = "$1";
            ".*/([^/]+)/([^/]+) - PCManFM" = "$1/$2";
            "(.*) - PCManFM" = "$1";
            ".*/([^/]+)/([^/]+) - Nautilus" = "$1/$2";
            "(.*) - Nautilus" = "$1";

            # === Terminales (extraer path del prompt tipo user@host:~/dir) ===
            "(.*@.*:)(~?/.*)" = "$2";
            "(.*@.*:)([^/]+)$" = "$2";

            # === Otras apps comunes ===
            "(.*) - Spotify" = "$1";
            "(.*) - Discord" = "$1";
            "(.*) - Obsidian" = "$1";
            "(.*) - GIMP" = "$1";
            "(.*) - Steam" = "$1";
          };
        };
        clock = {
          format = "  {:%A %d %B %Y %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          interval = 1;
        };
        cpu = {
          format = "  {usage}%";
          tooltip = true;
        };
        memory = { 
          format = "  {used:.1f}G / {total:.1f}G ({percentage}%)";  # ← Usado / Total (Porcentaje)
          tooltip = true;
        };
        battery = {
          states = { warning = 30; critical = 15; };
          format = "{icon} {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = "   {essid}";
          format-ethernet = "   {ipaddr}";
          format-disconnected = "   Offline";
          tooltip-format = "{ifname} via {gwaddr}\n{ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
        };
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} {dynamic}";
          player-icons = {
            default = "";
            spotify = "";
            firefox = "";
            chromium = "";
            google-chrome = "";
            # vlc = "嗢";
            mpv = "";
          };
          status-icons = {
            playing = "";
            paused = "";
            stopped = "";
          };
          max-length = 25;
          interval = 1;
          on-click = "playerctl play-pause";
          on-click-middle = "playerctl stop";
          on-click-right = "playerctl next";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        tray = { spacing = 10; };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }
      #window {
        padding: 0 12px;
        color: #cdd6f4;
      }

      /* Si usas icon: true, separa un poco el icono del texto */
#window image {
        margin-right: 8px;
      }

      /* Cuando no hay ventanas, oculta el módulo para no dejar hueco */
      window#waybar.empty #window {
        background-color: transparent;
        padding: 0;
        margin: 0;
      }
      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background-color: transparent;
        border: none;
        border-radius: 0;
      }
      #workspaces button:hover { background-color: #313244; }
      #workspaces button.active {
        background-color: #89b4fa;
        color: #1e1e2e;
      }
      #workspaces button.urgent { background-color: #f38ba8; }
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
        color: #cdd6f4;
      }
      #battery.critical:not(.charging) { color: #f38ba8; }
    '';
  };

  # ─────────────────────────────────────────────
  # Wofi
  # ─────────────────────────────────────────────
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #89b4fa;
        background-color: #1e1e2e;
        border-radius: 10px;
      }
      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 5px;
      }
      #inner-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
        border-radius: 5px;
      }
      #outer-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
      }
      #scroll { margin: 0px; border: none; }
      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }
      #entry:selected {
        background-color: #89b4fa;
        border-radius: 5px;
      }
      #entry:selected #text { color: #1e1e2e; }
    '';
  };

  # ============================================
  # HYPRLOCK (pantalla de bloqueo con estilo)
  # ============================================
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = {
        monitor = "";
        path = "screenshot";           # captura tu escritorio actual
        blur_passes = 2;
        blur_size = 7;
        brightness = 0.4;
        contrast = 0.8;
      };

      input-field = {
        monitor = "";
        size = "320, 65";
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        outer_color = "rgba(89b4faff)";
        inner_color = "rgba(30, 30, 46, 1.0)";
        font_color = "rgba(205, 214, 244, 1.0)";
        fade_on_empty = true;
        placeholder_text = "<i>Contraseña...</i>";   # <-- aquí cambias el feo "en"
        hide_input = false;
        rounding = 10;
        check_color = "rgba(166, 227, 161, 1.0)";
        position = "0, -80";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(205, 214, 244, 1.0)";
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 120";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 3;
        }
        {
          monitor = "";
          text = "-- Block --";
          color = "rgba(180, 190, 254, 1.0)";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -160";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # ============================================
  # HYPRIDLE (apagar pantalla por inactividad)
  # ============================================
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";  # bloquear si tienes hyprlock
        before_sleep_cmd = "loginctl lock-session";  # bloquear antes de suspender
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";  # encender pantalla al despertar
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
            timeout = 150;                                # 2.5min.
            # on-timeout = "brightnessctl -s set 10";        # set monitor backlight to minimum, avoid 0 on OLED monitor.
            # on-resume = "brightnessctl -r";                 # monitor backlight restore.
            on-timeout = "hyprctl hyprsunset gamma 10";   # baja brillo percibido al mínimo
            on-resume = "hyprctl hyprsunset reset gamma";     # restaura brillo y temperatura
        }
        {
            timeout = 300;                                 # 5min
            on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
        }
        {
          timeout = 330;                               # 5 minutos
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";    # apagar pantalla
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";      # encender al mover mouse/teclado
        }
        # {
        #   timeout = 600;                               # 10 minutos
        #   on-timeout = "systemctl suspend";              # suspender
        # }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [
        "/media/cris/Jazz/Images/ubuntu_rain.png"
        "/media/cris/Jazz/Images/UbuntuClouds.jpg"
      ];
      wallpaper = [
        {
          monitor = "";  # "" = todos los monitores (fallback)
          path = "/media/cris/Jazz/Images/ubuntu_rain.png";
          fit_mode = "cover";  # cover, contain, tile
        }
        # Si quieres diferentes wallpapers por monitor:
        # {
        #   monitor = "HDMI-A-1";
        #   path = "/media/cris/Jazz/Images/UbuntuClouds.jpg";
        # }
        # {
        #   monitor = "HDMI-A-2";
        #   path = "/media/cris/Jazz/Images/ubuntu-wallpapers-Bubbles.png";
        # }
      ];
    };
  };

  # ─────────────────────────────────────────────
  # Mako
  # ─────────────────────────────────────────────
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = false;        # respeta el timeout
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-size = 2;
      border-radius = 10;
      padding = "10";
      margin = "10";
      font = "JetBrains Mono 11";
    };
  };

    ## commands:
  ## makoctl history
  ## makoctl history -j ## formato json

  # ============================================
  # WLOGOUT (menú de apagado/reinicio/suspender)
  # ============================================
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock"; action = "loginctl lock-session"; text = "Bloquear"; keybind = "l"; }
      { label = "logout"; action = "hyprctl dispatch exit"; text = "Cerrar sesión"; keybind = "e"; }
      # { label = "suspend"; action = "systemctl suspend"; text = "Suspender"; keybind = "u"; }
      # { label = "hibernate"; action = "systemctl hibernate"; text = "Hibernar"; keybind = "h"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Apagar"; keybind = "s"; }
      { label = "reboot"; action = "systemctl reboot"; text = "Reiniciar"; keybind = "r"; }
    ];
    style = ''
      * {
        background-image: none;
        font-family: "JetBrains Mono";
        font-size: 16px;
      }
      window {
        background-color: rgba(30, 30, 46, 0.95);
      }
      button {
        color: #cdd6f4;
        background-color: #313244;
        border: 2px solid #45475a;
        border-radius: 10px;
        margin: 10px;
        padding: 20px;
      }
      button:hover {
        background-color: #89b4fa;
        color: #1e1e2e;
      }
      button:focus {
        background-color: #b4befe;
        color: #1e1e2e;
      }
    '';
  };
}
