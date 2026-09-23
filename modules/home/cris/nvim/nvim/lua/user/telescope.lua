-- ============================================================
-- Telescope
-- ============================================================
local telescope       = require("telescope")
local builtin         = require("telescope.builtin")
local actions         = require("telescope.actions")
local project_actions = require("telescope._extensions.project.actions")

telescope.setup({
  defaults = {
    -- Abrir en normal mode en lugar de insert mode
    --     default_mode = "normal",
    initial_mode = "normal",

    layout_strategy = "vertical",
    -- layout_strategy = "horizontal",
    sorting_strategy = "ascending",

    mappings = {
      i = {
        ["<C-c>"] = function() vim.cmd("stopinsert") end, -- regresa a normal mode
      },

      -- Mappings en normal mode (navegación con WASD)
      n = {
        ["s"]          = actions.move_selection_next,     -- bajar en la lista
        ["w"]          = actions.move_selection_previous, -- subir en la lista
        ["a"]          = actions.close,                   -- cerrar (o podrías usar para ir atrás)
        ["d"]          = actions.select_default,          -- abrir el archivo seleccionado

        -- Por si prefieres también las flechas y otros útiles
        ["<CR>"]       = actions.select_default,
        ["<C-x>"]      = actions.select_horizontal, -- abrir en split horizontal
        ["<C-v>"]      = actions.select_vertical,   -- abrir en split vertical
        ["<C-t>"]      = actions.select_tab,        -- abrir en nueva tab
        ["<Esc>"]      = actions.close,
        ["q"]          = actions.close,

        -- Previsualización
        ["<C-u>"]      = actions.preview_scrolling_up,
        ["<C-d>"]      = actions.preview_scrolling_down,

        -- Páginas en la lista
        ["<PageUp>"]   = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
      },
    },
    ---
  }, -- defaults

  extensions = {
    -- telescope-project
    project = {

      base_dirs           = {
        "~/Documents", -- ajusta a tus directorios de proyectos
        -- "~/../../Documents", -- ajusta a tus directorios de proyectos
        --"~/Projects",
      },
      hidden_files        = false,
      order_by            = "asc", -- recent
      sync_with_nvim_tree = false,
      mappings            = {
        n = {
          ['w'] = project_actions.delete_project,
          ['d'] = project_actions.change_working_directory,
        }
      }
    },

    -- telescope-file-browser
    file_browser = {
      -- iniciar en el directorio del archivo actual
      -- path            = "%:p:h",
      -- cwd             = vim.fn.expand("%:p:h"),
      respect_gitignore = false,
      hidden            = true, -- mostrar archivos ocultos
      grouped           = true, -- directorios primero
      --previewer       = true,  -- sin preview para que sea más compacto
      -- hijack_netrw = true,
      hijack_netrw      = true,
      initial_mode      = "normal",
      --layout_config   = { height = 0.5 },
      mappings          = {
        n = {
          ["s"] = actions.move_selection_next,
          ["w"] = actions.move_selection_previous,
        },
      },
    }, -- file browser
  },   -- extensions
})

-- Cargar extensiones
telescope.load_extension("project")
telescope.load_extension("file_browser")

-- Keymaps globales para abrir Telescope
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

-- Archivos y texto
map("<leader>fF", builtin.find_files, "Telescope: archivos del proyecto")
map("<leader>ff", builtin.fd, "Telescope: fd")
map("<leader>fg", builtin.live_grep, "Telescope: grep en vivo")
map("<leader>fw", builtin.grep_string, "Telescope: buscar palabra bajo cursor")
-- map("<leader>fb", builtin.buffers,            "Telescope: buffers abiertos")
vim.keymap.set('n', '<leader>fr', function()
  require('telescope.builtin').buffers({
    sort_mru = true,
    sort_lastused = true,
    -- ignore_current_buffer = true,
  })
end, {})
map("<leader>fR", builtin.oldfiles, "Telescope: archivos recientes")

-- File browser y proyectos
-- map("<leader>fe", function()
--     telescope.extensions.file_browser.file_browser({ cwd = vim.fn.expand("%:p:h") })
-- end, "Telescope: archivos del directorio actual")
map("<leader>fp", telescope.extensions.project.project, "Telescope: proyectos")
vim.keymap.set('n', '<leader>fe', function()
  -- 1. Obtenemos la ruta de la carpeta del archivo actual
  local current_dir = vim.fn.expand('%:p:h')

  -- 2. Si estamos en un buffer vacío sin ruta (ej. el inicio), usamos el CWD
  if current_dir == "" then
    current_dir = vim.fn.getcwd()
  end

  -- 3. Ejecutamos find_files limitado a esa carpeta
  require('telescope.builtin').find_files({
    desc = "Buscar solo en la carpeta del archivo actual",
    cwd = current_dir,
    find_command = { "fd", "--type", "f", "--max-depth", "1" }
  })
end, { desc = "Buscar archivos en carpeta actual sin subcarpetas" })


vim.keymap.set("n", "<leader>fo", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
map("<leader>fO", telescope.extensions.file_browser.file_browser, "Telescope: file browser")
map("<leader>fz", builtin.current_buffer_fuzzy_find, "Telescope: buffer fuzzy find")
-- vim.keymap.set("n", "<leader>fE", ":Telescope file_browser<CR>")

-- LSP (requiere estar en un buffer con LSP activo)
map("<leader>fs", builtin.lsp_document_symbols, "Telescope: símbolos del archivo")
map("<leader>fS", builtin.lsp_workspace_symbols, "Telescope: símbolos del proyecto")
map("<leader>fD", builtin.diagnostics, "Telescope: diagnósticos LSP")
map("<leader>fd", builtin.lsp_references, "Telescope: referencias")
map("<leader>fi", builtin.lsp_implementations, "Telescope: implementaciones")

-- Git
map("<leader>gc", builtin.git_commits, "Telescope: commits git")
map("<leader>gb", builtin.git_branches, "Telescope: ramas git")
map("<leader>gs", builtin.git_status, "Telescope: status git")

-- Nvim
map("<leader>fk", builtin.keymaps, "Telescope: ver todos los keymaps")
map("<leader>fC", builtin.commands, "Telescope: comandos de nvim")
map("<leader>fh", builtin.help_tags, "Telescope: documentación de ayuda")
map("<leader>ft", builtin.filetypes, "Telescope: cambiar filetype del buffer")
