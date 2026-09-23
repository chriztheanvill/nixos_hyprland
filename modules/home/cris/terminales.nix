{ config, pkgs, username, ... }:

{
  # ============================================
  # KITTY
  # ============================================
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = "11.0";
      background_opacity = "0.95";
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";
      selection_background = "#353749";
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#94e2d5";
      color7 = "#bac2de";
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";
      enable_audio_bell = false;
      scrollback_lines = 10000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 4;
      confirm_os_window_close = 0;
    };
  };

  # ============================================
  # GHOSTTY
  # ============================================
  programs.ghostty = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      font-family = "FiraCode Nerd Font Mono";
      # font-family = "JetBrainsMono Nerd Font";
      font-size = 11;
      font-thicken = false;

      # ---- Tema ----
      theme = "Ayu";
      # Para ver todos los temas disponibles: ghostty +list-themes

      # ---- Window ----
      window-save-state = "always";
      window-width = 120;
      window-height = 70;
      window-vsync = true;

      # ---- Ventana ----
      window-padding-x = 4;
      window-padding-y = 4;
      window-decoration = true;
      confirm-close-surface = false;

      # ---- Cursor ----
      cursor-style = "block";
      cursor-style-blink = true;

      # ---- Scrollback ----
      scrollback-limit = 100000;

      # ---- Shell integration ----
      shell-integration = "zsh";
      # shell-integration-features = "no-cursor";

      # ---- Terminal ----
      term = "xterm-256color";

      # ---- Clipboard ----
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;

      # ---- Keybinds ----
      keybind = [
        # Splits
        "ctrl+shift+d=new_split:right"
        "ctrl+shift+e=new_split:down"

        # Redimensionar splits (en incrementos de 10px)
        "ctrl+shift+alt+h=resize_split:left,10"
        "ctrl+shift+alt+l=resize_split:right,10"
        "ctrl+shift+alt+k=resize_split:up,10"
        "ctrl+shift+alt+j=resize_split:down,10"

        # Moverse entre splits (estilo vim: h/j/k/l)
        "ctrl+alt+h=goto_split:left"
        "ctrl+alt+l=goto_split:right"
        "ctrl+alt+k=goto_split:up"
        "ctrl+alt+j=goto_split:down"

        # Igualar tamaño de splits / zoom a un split
        "ctrl+shift+w=equalize_splits"
        "ctrl+shift+z=toggle_split_zoom"

        # Cerrar split actual
        "ctrl+shift+q=close_surface"

        # Pestañas (tabs)
        "ctrl+shift+t=new_tab"
        "ctrl+shift+right_bracket=next_tab"
        "ctrl+shift+left_bracket=previous_tab"

        # "ctrl+shift+f=text_editing:jump_to_prompt"
      ];
    };
  };
}
