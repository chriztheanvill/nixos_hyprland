{ config, pkgs, inputs, ... }:
{
  # Importa el módulo oficial de Home Manager de Noctalia
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    # Configuración declarativa (se traduce a ~/.config/noctalia/settings.toml)
    settings = {
      theme = {
        mode = "dark";                    # dark | light | auto
        source = "builtin";               # builtin | wallpaper | community | custom
        builtin = "Catppuccin";           # tema activo (ver lista abajo)
        pure_black_dark = false;
      };

      wallpaper = {
        enabled = true;
        default = {
          path = "/media/cris/Jazz/Images/ubuntu_rain.png";
          fit_mode = "cover";             # cover | contain | tile
        };
      };

      bar = {
        enabled = true;
        # Noctalia detecta automáticamente los monitores.
        # Puedes añadir widgets personalizados aquí si lo deseas.
      };

      launcher = {
        enabled = true;
        # Reemplaza a Wofi. Atajo por defecto: Super + Space (configurable)
      };

      notifications = {
        enabled = true;
        # Reemplaza a Mako
      };

      lock = {
        enabled = true;
        # Reemplaza a Hyprlock (usa PAM nativo)
      };

      control_center = {
        enabled = true;
        # Panel de red, bluetooth, audio, energía, etc.
      };

      # Noctalia puede auto-generar configs temáticas para otras apps.
      # Habilita las que uses:
      templates = {
        activeTemplates = [
          "gtk3"
          "gtk4"
          "qt"
          # "ghostty"
          # "alacritty"
          # "kitty"
        ];
      };
    };
  };
}

