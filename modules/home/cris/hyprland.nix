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
      -- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

      -- ============================================
      -- PROGRAMS
      -- ============================================
      local terminal    = "ghostty --working-directory=~/Downloads"
      -- local terminal    = "kitty -d ~/Downloads"
      local fileManager = "thunar ~/Downloads"
      local browser     = "brave"

      -- ============================================
      -- AUTOSTART
      -- ============================================
      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia")
        -- hl.exec_cmd("easyeffects")
        -- hl.exec_cmd("seahorse")

        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'") -- Cambia 'Adwaita-dark' por tu tema
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'") -- Cambia 'Adwaita-dark' por tu tema
        -- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")
        hl.exec_cmd("qmmp")
        hl.exec_cmd("strawberry")
        -- hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
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
          kb_options = "ctrl:nocaps",  -- Deshabilitar Caps por Ctrl
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
      hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + M", hl.dsp.exit())
      hl.bind(mod .. " + A", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
      -- hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + V", function()
          hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
          local w = hl.get_active_window()
          if w ~= nil and w.floating then
              hl.dispatch(hl.dsp.window.resize({ x = 1000, y = 1200, relative = false }))
              hl.dispatch(hl.dsp.window.center())
          end
      end)

      -- 1. Avanzar por TODAS las ventanas (Tiled y Floating)
      hl.bind(mod .. " + Tab", function()
          hl.dispatch(hl.dsp.window.cycle_next())
          hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
      end, { description = "Cycle forward through all windows (tiled and floating)" })

      -- 2. Retroceder por TODAS las ventanas (Orden Invertido)
      hl.bind(mod .. " + SHIFT + Tab", function()
          hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
          -- hl.dispatch(hl.dsp.window.cycle_next("prev"))
          hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
      end, { description = "Cycle backward through all windows (tiled and floating)" })

      -- -- Toggle focus entre tiled y floating (como Sway/i3) + Traer al frente si es flotante
      -- hl.bind(mod .. " + Tab", function()
      --     local w = hl.get_active_window()
      --     if w == nil then return end
      --     
      --     -- 1. Cambiamos el enfoque a la siguiente ventana según su estado
      --     hl.dispatch(hl.dsp.window.cycle_next({
      --         floating = not w.floating
      --     }))
      --     
      --     -- 2. Traemos al frente la ventana recién enfocada usando alter_zorder
      --     hl.dispatch(hl.dsp.window.alter_zorder({ 
      --         mode = "top" 
      --     }))
      -- end, { description = "Switch focus between tiled and floating windows and bring to top" })

      -- -- old
      -- Toggle focus entre tiled y floating (como Sway/i3)
      -- hl.bind(mod .. " + Tab", function()
      --     local w = hl.get_active_window()
      --     if w == nil then return end
      --     
      --     hl.dispatch(hl.dsp.window.cycle_next({
      --         floating = not w.floating
      --     }))
      -- end, { description = "Switch focus between tiled and floating windows" })

      -- Launcher Noctalia (reemplaza Wofi)
      hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

      hl.bind(mod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))

      hl.bind(mod .. " + Y", hl.dsp.layout("togglesplit"))
      hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
      hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

      -- Lock con Noctalia (reemplaza Hyprlock)
      hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("noctalia msg session lock"))

      -- Power Menu vía Noctalia Control Center (o mantén tu script de wofi si prefieres)
      hl.bind(mod .. " + Z", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))

      -- Settings
      hl.bind(mod .. " + Comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))

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
      -- hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
      -- hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
      -- hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
      -- hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

      local move_step = 50

      -- H: izquierda
      hl.bind(mod .. " + SHIFT + H", function()
          local w = hl.get_active_window()
          if w ~= nil and w.floating then
              hl.dispatch(hl.dsp.window.move({ x = -move_step, y = 0, relative = true }))
          else
              hl.dispatch(hl.dsp.window.swap({ direction = "l" }))
          end
      end)

      -- J: abajo
      hl.bind(mod .. " + SHIFT + J", function()
          local w = hl.get_active_window()
          if w ~= nil and w.floating then
              hl.dispatch(hl.dsp.window.move({ x = 0, y = move_step, relative = true }))
          else
              hl.dispatch(hl.dsp.window.swap({ direction = "d" }))
          end
      end)

      -- K: arriba
      hl.bind(mod .. " + SHIFT + K", function()
          local w = hl.get_active_window()
          if w ~= nil and w.floating then
              hl.dispatch(hl.dsp.window.move({ x = 0, y = -move_step, relative = true }))
          else
              hl.dispatch(hl.dsp.window.swap({ direction = "u" }))
          end
      end)

      -- L: derecha
      hl.bind(mod .. " + SHIFT + L", function()
          local w = hl.get_active_window()
          if w ~= nil and w.floating then
              hl.dispatch(hl.dsp.window.move({ x = move_step, y = 0, relative = true }))
          else
              hl.dispatch(hl.dsp.window.swap({ direction = "r" }))
          end
      end)

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

      -- O con teclado, por ejemplo bracket keys:
      hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "+1" }))
      hl.bind(mod .. " + bracketleft",  hl.dsp.focus({ workspace = "-1" }))
      hl.bind(mod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind(mod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }))

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
      -- hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("hyprctl hyprsunset reset gamma"))

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

      -- Thunar popups
      -- hl.window_rule({ match = { class = "thunar", title = "^Rename.*" },           float = true, center = true, size = { 500, 200 } })
      -- hl.window_rule({ match = { class = "thunar", title = "^File Operation Progress$" }, float = true, center = true, size = { 500, 200 } })
      -- hl.window_rule({ match = { class = "thunar", title = "^Confirm.*" },            float = true, center = true })
      -- hl.window_rule({ match = { class = "thunar", title = "^Create.*" },              float = true, center = true })
      -- hl.window_rule({ match = { class = "thunar", title = ".*Properties$" },         float = true, center = true })

      -- Thunar: Hacer flotantes los diálogos (Copiar, Mover, Renombrar, Propiedades, etc.)
      hl.window_rule({ 
        match = { class = "thunar", title = "^(Copy|Move|Rename|Delete|Properties|Empty Trash|File Operation|Confirm).*" }, 
        float = true, 
        center = true,
        size = { 600, 400 } -- Ajusta el tamaño si lo necesitas
      })

    '';
  };

  ##
}
