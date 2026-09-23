-- https://github.com/folke/snacks.nvim
local Snacks = require("snacks")

-- ============================================================
-- Snacks (picker + explorer) — traducido desde Telescope
-- ============================================================
Snacks.setup({
  bigfile = { enabled = true },
  -- dashboard = { enabled = true }, -- solo requiere lazy git
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys",         gap = 1,    padding = 1 },
      { section = "recent_files", limit = 8,  padding = 1 },
      { section = "projects",     padding = 1 },
    },
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },

  -- ============================================================
  -- Picker (antes: telescope defaults)
  -- ============================================================
  picker = {
    enabled = true,

    -- initial_mode = "normal"
    on_show = function()
      vim.cmd("stopinsert")
    end,

    win = {
      input = {
        keys = {
          -- ["<C-c>"] = { "stopinsert", mode = "i" },
          ["<C-c>"] = {
            function()
              vim.cmd("stopinsert")
            end,
            mode = { "i" },
          }, -- C-c
          -- Navegación WASD en modo normal (igual que telescope)
          ["s"]     = { "list_down", mode = { "n" } },
          ["w"]     = { "list_up", mode = { "n" } },
          -- ["a"]          = { "close", mode = { "n" } },
          ["d"]     = { "confirm", mode = { "n" } },

          ["<CR>"]  = { "confirm", mode = { "n", "i" } },
          ["<C-x>"] = { "edit_split", mode = { "n", "i" } },
          ["<C-v>"] = { "edit_vsplit", mode = { "n", "i" } },
          ["<C-t>"] = { "edit_tab", mode = { "n", "i" } },
          ["<Esc>"] = { "close", mode = { "n" } },
          ["q"]     = { "close", mode = { "n" } },
          -- ["<C-u>"]      = { "preview_scroll_up", mode = { "n", "i" } },
          -- ["<C-d>"]      = { "preview_scroll_down", mode = { "n", "i" } },
          -- ["<PageUp>"]   = { "list_scroll_up", mode = { "n", "i" } },
          -- ["<PageDown>"] = { "list_scroll_down", mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["s"] = "list_down", -- bajar
          ["w"] = "list_up",   -- subir
          ["a"] = "close",     -- cerrar
          ["d"] = "confirm",   -- abrir
          -- ["<CR>"]       = "confirm",
          -- ["<C-x>"]      = "edit_split",  -- split horizontal
          -- ["<C-v>"]      = "edit_vsplit", -- split vertical
          -- ["<C-t>"]      = "edit_tab",    -- nueva tab
          -- ["<Esc>"]      = "close",
          -- ["q"]          = "close",
          -- ["<C-u>"]      = "preview_scroll_up",
          -- ["<C-d>"]      = "preview_scroll_down",
          -- ["<PageUp>"]   = "list_scroll_up",
          -- ["<PageDown>"] = "list_scroll_down",
        },
      },
    },

    sources = {
      -- telescope-file-browser
      explorer = {
        hidden  = true, -- mostrar archivos ocultos
        ignored = true, -- respect_gitignore = false
      },
      -- telescope-project: dónde buscar proyectos
      projects = {
        dev = {
          "~/Documents",
          "/media/cris/Jazz/Documents/Obsidian",
        },
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "*.code-workspace" },
      },
    },
  },

  -- ============================================================
  -- Explorer (antes: file_browser hijack_netrw)
  -- ============================================================
  explorer = {
    enabled = true,
    replace_netrw = true, -- hijack_netrw
  },
})

-- ============================================================
-- Keymaps (vim.pack: sin tabla `keys`, usamos vim.keymap.set)
-- ============================================================
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

-- Archivos y texto
map("<leader>fF", function() Snacks.picker.files() end, "Archivos del proyecto")
map("<leader>ff", function() Snacks.picker.files() end, "Find files (fd)")
map("<leader>fg", function() Snacks.picker.grep() end, "Grep en vivo")
map("<leader>fw", function() Snacks.picker.grep_word() end, "Palabra bajo cursor")

-- Buffers y recientes (sort_mru → sort_lastused)
map("<leader>fr", function()
  Snacks.picker.buffers({ sort_lastused = true, current = false })
end, "Buffers (MRU)")
map("<leader>fR", function() Snacks.picker.recent() end, "Archivos recientes")

-- Proyectos y explorador
map("<leader>fp", function() Snacks.picker.projects() end, "Proyectos")
map("<leader>fO", function() Snacks.explorer() end, "File explorer")
map("<leader>fo", function()
  Snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
end, "Explorer en carpeta del archivo actual")

-- <leader>fe (archivos de la carpeta actual, sin subcarpetas)
-- No hay --max-depth 1 directo; lo más cercano es files() con cwd:
map("<leader>fe", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  Snacks.picker.files({ cwd = dir })
end, "Archivos de la carpeta actual")

map("<leader>fz", function() Snacks.picker.lines() end, "Fuzzy find en buffer")

-- LSP
map("<leader>fs", function() Snacks.picker.lsp_symbols() end, "Símbolos del archivo")
map("<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, "Símbolos del proyecto")
map("<leader>fD", function() Snacks.picker.diagnostics() end, "Diagnósticos LSP")
map("<leader>fd", function() Snacks.picker.lsp_references() end, "Referencias")
map("<leader>fi", function() Snacks.picker.lsp_implementations() end, "Implementaciones")

-- Git
map("<leader>gc", function() Snacks.picker.git_log() end, "Commits git")
map("<leader>gb", function() Snacks.picker.git_branches() end, "Ramas git")
map("<leader>gs", function() Snacks.picker.git_status() end, "Status git")
map("<leader>gf", function() Snacks.picker.git_files() end, "Git files")

-- Nvim
map("<leader>fk", function() Snacks.picker.keymaps() end, "Keymaps")
map("<leader>fC", function() Snacks.picker.commands() end, "Comandos")
map("<leader>fh", function() Snacks.picker.help() end, "Help tags")

-- Top pickers
map("<leader><space>", function() Snacks.picker.smart() end, "Smart Find Files")
map("<leader>,", function() Snacks.picker.buffers() end, "Buffers")
map("<leader>/", function() Snacks.picker.grep() end, "Grep")
map("<leader>:", function() Snacks.picker.command_history() end, "Command History")
map("<leader>n", function() Snacks.picker.notifications() end, "Notification History")
map("<leader>e", function() Snacks.explorer() end, "File Explorer")

-- find (faltantes)
map("<leader>fb", function() Snacks.picker.buffers() end, "Buffers")
map("<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File")

-- git (faltantes)
map("<leader>gl", function() Snacks.picker.git_log() end, "Git Log")
map("<leader>gL", function() Snacks.picker.git_log_line() end, "Git Log Line")
map("<leader>gS", function() Snacks.picker.git_stash() end, "Git Stash")
map("<leader>gd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)")

-- gh (opcional, requiere GitHub CLI)
map("<leader>gi", function() Snacks.picker.gh_issue() end, "GitHub Issues (open)")
map("<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, "GitHub Issues (all)")
map("<leader>gp", function() Snacks.picker.gh_pr() end, "GitHub Pull Requests (open)")
map("<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, "GitHub Pull Requests (all)")

-- Grep (faltantes)
map("<leader>sb", function() Snacks.picker.lines() end, "Buffer Lines")
map("<leader>sB", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep word/selection" })

-- search (faltantes)
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
map("<leader>sa", function() Snacks.picker.autocmds() end, "Autocmds")
map("<leader>sc", function() Snacks.picker.command_history() end, "Command History")
map("<leader>sC", function() Snacks.picker.commands() end, "Commands")
map("<leader>sd", function() Snacks.picker.diagnostics() end, "Diagnostics")
map("<leader>sD", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics")
map("<leader>sh", function() Snacks.picker.help() end, "Help Pages")
map("<leader>sH", function() Snacks.picker.highlights() end, "Highlights")
map("<leader>si", function() Snacks.picker.icons() end, "Icons")
map("<leader>sj", function() Snacks.picker.jumps() end, "Jumps")
map("<leader>sk", function() Snacks.picker.keymaps() end, "Keymaps")
map("<leader>sl", function() Snacks.picker.loclist() end, "Location List")
map("<leader>sm", function() Snacks.picker.marks() end, "Marks")
map("<leader>sM", function() Snacks.picker.man() end, "Man Pages")
map("<leader>sq", function() Snacks.picker.qflist() end, "Quickfix List")
map("<leader>sR", function() Snacks.picker.resume() end, "Resume")
map("<leader>su", function() Snacks.picker.undo() end, "Undo History")
map("<leader>uC", function() Snacks.picker.colorschemes() end, "Colorschemes")

-- LSP (faltantes; nota: "gd" pisa el goto-definition nativo, tenlo en cuenta)
map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
map("gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
map("gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
map("gai", function() Snacks.picker.lsp_incoming_calls() end, "Calls Incoming")
map("gao", function() Snacks.picker.lsp_outgoing_calls() end, "Calls Outgoing")
map("<leader>ss", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

-- Otros (faltantes) — algunos requieren lazygit/gh instalados
-- map("<leader>z", function() Snacks.zen() end, "Toggle Zen Mode")
-- map("<leader>Z", function() Snacks.zen.zoom() end, "Toggle Zoom")
map("<leader>.", function() Snacks.scratch() end, "Toggle Scratch Buffer")
map("<leader>S", function() Snacks.scratch.select() end, "Select Scratch Buffer")
map("<leader>bd", function() Snacks.bufdelete() end, "Delete Buffer")
map("<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
-- map("<leader>gg", function() Snacks.lazygit() end, "Lazygit")
-- map("<leader>un", function() Snacks.notifier.hide() end, "Dismiss All Notifications")
vim.keymap.set("n", "<c-/>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
-- vim.keymap.set("n", "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })
-- vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
-- vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
