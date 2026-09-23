-- ============================================================
-- render-markdown.nvim
-- ============================================================
require("render-markdown").setup({
  completions = {
    lsp = { enabled = false },
  },
  -- Activar sólo en buffers Markdown y ayuda
  file_types = { "markdown", "help" },
  checkbox = {
    -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
    -- There are two special states for unchecked & checked defined in the markdown grammar.

    -- Turn on / off checkbox state rendering.
    enabled = true,
    -- Additional modes to render checkboxes.
    render_modes = true,
    -- Render the bullet point before the checkbox.
    bullet = true,
    -- Padding to add to the left of checkboxes.
    left_pad = 0,
    -- Padding to add to the right of checkboxes.
    right_pad = 1,
    unchecked = {
      -- Replaces '[ ]' of 'task_list_marker_unchecked'.
      icon = '󰄱 ', -- default
      -- Highlight for the unchecked icon.
      highlight = 'RenderMarkdownUnchecked',
      -- Highlight for item associated with unchecked checkbox.
      scope_highlight = nil,
    },
    checked = {
      -- Replaces '[x]' of 'task_list_marker_checked'.
      icon = '󰱒 ',
      -- Highlight for the checked icon.
      highlight = 'RenderMarkdownChecked',
      -- Highlight for item associated with checked checkbox.
      scope_highlight = nil,
    },
    -- Define custom checkbox states, more involved, not part of the markdown grammar.
    -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
    -- The key is for healthcheck and to allow users to change its values, value type below.
    -- | raw             | matched against the raw text of a 'shortcut_link'           |
    -- | rendered        | replaces the 'raw' value when rendering                     |
    -- | highlight       | highlight for the 'rendered' icon                           |
    -- | scope_highlight | optional highlight for item associated with custom checkbox |
    -- stylua: ignore
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
    },
    -- Priority to assign to scope highlight.
    scope_priority = nil,
  },
  pipe_table = {
    enabled = true,
    render_modes = true, -- que se renderice también en modo insert/visual, no solo normal
    cell = 'trimmed',    -- trimmed, overlay, raw, padded
    preset = 'round',    -- o 'none'/'normal' según tu gusto visual
  },
  link = {
    enabled = true,
    -- Esto fuerza a que el componente de links oculte el URL completo
    -- reduciendo el espacio físico consumido en la tabla
    -- inline = true,
    render_modes = true, -- clave: conceal el link incluso dentro de tablas
  },
})

-- Este me gusto
-- require('fk_markdown').setup({
--
--   -- ── Headings ──────────────────────────────────────────────
--   heading = {
--     enabled = true,
--     icon = true,
--
--     icons = {
--       '󰲡 ', '󰲣 ', '󰲥 ',
--       '󰲧 ', '󰲩 ', '󰲫 ',
--     },
--
--     background = {
--       enabled = false,
--
--       bg_color = {
--         "#1e1e2e", "#1e1e2e", "#1e1e2e",
--         "#1e1e2e", "#1e1e2e", "#1e1e2e",
--       },
--
--       font_color = {
--         "#f38ba8", "#fab387", "#f9e2af",
--         "#a6e3a1", "#74c7ec", "#cba6f7",
--       },
--     },
--   },
--
--   -- ── Code Blocks ───────────────────────────────────────────
--   code = {
--     enabled = true,
--     style = 'wide',
--
--     background = {
--       enabled = false,
--       color = "#181825",
--     },
--
--     padding = {
--       top = 1,
--       bottom = 1,
--       left = 1,
--       right = 2,
--     },
--
--     border = {
--       enabled = true,
--       type = "dynamic",
--       color = "#f38ba8",
--     },
--
--     title = {
--       enabled = true,
--       type = "dynamic",
--       color = "#a6e3a1",
--     },
--
--     icon = {
--       enabled = true,
--     },
--   },
--
--   -- ── Callouts ──────────────────────────────────────────────
--   quote = {
--     enabled = true,
--     style = 'boxy',
--     border = true,
--     bg = "NONE",
--     fg = "#cad3f5",
--   },
--
--   -- ── Bullets ───────────────────────────────────────────────
--   bullet = {
--     enabled = true,
--     icons = { '●', '○', '◆', '◇' },
--   },
--
--   -- ── Checkboxes ────────────────────────────────────────────
--   checkbox = {
--     enabled = true,
--
--     unchecked = {
--       icon = '󰄱 ',
--       highlight = 'RenderMarkdownUnchecked',
--     },
--
--     checked = {
--       icon = '󰱒 ',
--       highlight = 'RenderMarkdownChecked',
--     },
--   },
--
--   -- ── Tables ────────────────────────────────────────────────
--   pipe_table = {
--     enabled = true,
--     preset = 'none',
--     style = 'full',
--     -- 'padded' | 'trimmed' | 'raw' | 'overlay'
--     cell = 'trimmed',
--   },
--
--   -- ── Links ─────────────────────────────────────────────────
--   link = {
--     enabled = true,
--     image = '󰥶 ',
--     hyperlink = '󰌹 ',
--   },
--
--   -- ── Thematic Breaks ───────────────────────────────────────
--   dash = {
--     enabled = true,
--     icon = '─',
--   },
--
--   -- ── Signs ─────────────────────────────────────────────────
--   sign = {
--     enabled = true,
--   },
--
--   -- ── Indentation ───────────────────────────────────────────
--   indent = {
--     enabled = false,
--   },
-- })
