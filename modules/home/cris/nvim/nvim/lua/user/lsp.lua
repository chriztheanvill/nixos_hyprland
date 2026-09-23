-- ═══════════════════════════════════════════════════════════════
-- 1. OPCIONES NATIVAS DE AUTOCOMPLETADO (Neovim 0.12)
-- ═══════════════════════════════════════════════════════════════
-- Estas opciones están activadas en otro archivo:
vim.o.autocomplete = true
--   vim.o.complete = ".^10,w,b,u,t"
--   vim.o.completeopt = "menuone,noselect,popup"
--   vim.o.pumborder = "rounded"
--   vim.o.pumheight = 15

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ═══════════════════════════════════════════════════════════════
-- 2. ICONOS DE AUTOCOMPLETADO
-- ═══════════════════════════════════════════════════════════════
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "󰣙",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "󰕘",
  Module = "󰏗",
  Property = "󰜢",
  Unit = "󰐂",
  Value = "󰎩",
  Enum = "󰉺",
  Keyword = "󰌋",
  Snippet = "󰆓",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "󰉺",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "󰃐",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
for kind, icon in pairs(kind_icons) do
  local idx = CompletionItemKind[kind]
  if idx then
    CompletionItemKind[idx] = icon .. " "
  end
end

-- ═══════════════════════════════════════════════════════════════
-- 3. CAPABILITIES GLOBALES
-- ═══════════════════════════════════════════════════════════════
local lsp_capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  {
    textDocument = {
      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          preselectSupport = true,
          deprecatedSupport = true,
          documentationFormat = { "markdown", "plaintext" },
          labelDetailsSupport = true,
          insertReplaceSupport = true,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits", "command" },
          },
        },
      },
      semanticTokens = {
        dynamicRegistration = false,
        tokenTypes = {
          "namespace", "type", "class", "enum", "interface", "struct", "typeParameter",
          "parameter", "variable", "property", "enumMember", "event", "function",
          "method", "macro", "keyword", "modifier", "comment", "string", "number",
          "regexp", "operator",
        },
        tokenModifiers = {
          "declaration", "definition", "readonly", "static", "deprecated",
          "abstract", "async", "modification", "documentation", "defaultLibrary",
        },
        formats = { "relative" },
      },
      inlayHint = {
        dynamicRegistration = false,
        resolveSupport = {
          properties = { "tooltip", "location", "command" },
        },
      },
    },
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
      workspaceFolders = true,
      configuration = true,
    },
  }
)

vim.lsp.config("*", {
  capabilities = lsp_capabilities,
})

-- ═══════════════════════════════════════════════════════════════
-- 4. LSP ATTACH (Neovim 0.12)
-- ═══════════════════════════════════════════════════════════════
-- Neovim 0.12 trae keymaps globales por defecto:
--   gra = code action,  gri = implementation,  grn = rename,
--   grr = references,   grt = type definition, grx = codelens,
--   gO  = document symbols,  <C-S> (insert) = signature help

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client then return end

    -- En buffers con LSP activo, forzar que 'complete' solo use omnifunc (LSP).
    -- Esto evita que aparezcan palabras del buffer/ventanas sin iconos
    -- mezcladas con los items del LSP (con iconos).
    -- vim.bo[bufnr].complete = "o"

    -- Autocompletado LSP con autotrigger (Neovim 0.12 nativo)
    -- NOTA: { autotrigger = true } ya se encarga de re-triggerear
    -- automáticamente al escribir. No se necesita TextChangedI manual.
    -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

    -- Autocompletado LSP con autotrigger (Neovim 0.12 nativo)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- CodeLens
    if client:supports_method("textDocument/codeLens") then
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    -- Document Highlight
    if client:supports_method("textDocument/documentHighlight") then
      local doc_highlight_au = vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      local doc_clear_au = vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
      -- Solo crear un LspDetach por buffer, no por cliente
      if not vim.b[bufnr]._lsp_doc_highlight_setup then
        vim.b[bufnr]._lsp_doc_highlight_setup = true
        vim.api.nvim_create_autocmd("LspDetach", {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.api.nvim_del_autocmd(doc_highlight_au)
            vim.api.nvim_del_autocmd(doc_clear_au)
            vim.lsp.buf.clear_references()
            vim.b[bufnr]._lsp_doc_highlight_setup = nil
          end,
        })
      end
    end

    -- CodeLens
    if client:supports_method("textDocument/codeLens") then
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    -- Keymaps personalizados
    local bufopts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, bufopts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, bufopts)
    -- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  end,
})

-- -- Restaurar fuentes de completado originales cuando el último LSP se desconecta
-- -- solo activar esto, cuando se use vim.bo[bufnr].complete = "o"
-- vim.api.nvim_create_autocmd("LspDetach", {
--   callback = function(args)
--     local bufnr = args.buf
--     -- Solo restaurar si no quedan clientes LSP con capacidad de completion
--     local remaining = vim.lsp.get_clients({
--       bufnr = bufnr,
--       method = "textDocument/completion",
--     })
--     if #remaining == 0 then
--       vim.bo[bufnr].complete = ".^10,w,b,u,t"
--     end
--   end,
-- })

-- ═══════════════════════════════════════════════════════════════
-- 5. CONFIGURACIÓN DE SERVIDORES (vim.lsp.config) — 0.12
-- ═══════════════════════════════════════════════════════════════
vim.lsp.config("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
})

vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "build.zig", "build.zig.zon", ".git" },
})

vim.lsp.config("gdscript", {
  cmd = { "ncat", "127.0.0.1", "6005" }, -- Godot expone el LSP vía TCP
  filetypes = { "gd", "gdscript", "gdscript3" },
  root_markers = { "project.godot", ".git" },
  -- single_file_support = true,
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "CMakeLists.txt", ".git" },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
      hint = {
        enable = true,
        setType = true,
        paramType = true,
        paramName = "Literal",
        arrayIndex = "Disable",
      },
    },
  },
})

vim.lsp.config("marksman", {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", ".git" },
})

vim.lsp.config("sqls", {
  cmd = { "sqls" },
  filetypes = { "sql", "mysql", "plsql" },
  root_markers = { ".sqls.yml", ".sqls.yaml", ".git" },
})

-- ═══════════════════════════════════════════════════════════════
-- 6. HABILITAR SERVIDORES
-- ═══════════════════════════════════════════════════════════════
vim.lsp.enable({ "bashls", "zls", "gdscript", "clangd", "lua_ls", "marksman", "sqls" })

-- ═══════════════════════════════════════════════════════════════
-- 7. FORMAT ON SAVE
-- ═══════════════════════════════════════════════════════════════
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local bufnr = args.buf
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })

    if #clients == 0 then return end

    local client = clients[1]
    for _, c in ipairs(clients) do
      if c.name ~= "null-ls" and c.name ~= "conform" then
        client = c
        break
      end
    end

    vim.lsp.buf.format({
      bufnr = bufnr,
      async = false,
      timeout_ms = 2000,
      filter = function(c) return c.id == client.id end,
    })
  end,
})

-- ═══════════════════════════════════════════════════════════════
-- 8. DIAGNÓSTICOS
-- ═══════════════════════════════════════════════════════════════
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN]  = "󰀪",
      [vim.diagnostic.severity.INFO]  = "󰋽",
      [vim.diagnostic.severity.HINT]  = "󰌶",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    max_width = 80,
  },
})

-- -- ═══════════════════════════════════════════════════════════════
-- -- 9. HIGHLIGHTS DE REFERENCIAS
-- -- ═══════════════════════════════════════════════════════════════
-- vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3b4261", bold = true })
-- vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3b4261", bold = true })
-- vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3b4261", bold = true, underline = true })
--
-- -- ═══════════════════════════════════════════════════════════════
-- -- 10. TOGGLE INLAY HINTS
-- -- ═══════════════════════════════════════════════════════════════
-- vim.keymap.set("n", "<leader>ih", function()
--   local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
--   vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
--   vim.notify("Inlay hints: " .. (not enabled and "ON" or "OFF"))
-- end, { desc = "LSP: toggle inlay hints (buffer)" })
--
-- vim.keymap.set("n", "<leader>iH", function()
--   local enabled = vim.lsp.inlay_hint.is_enabled()
--   vim.lsp.inlay_hint.enable(not enabled)
--   vim.notify("Inlay hints global: " .. (not enabled and "ON" or "OFF"))
-- end, { desc = "LSP: toggle inlay hints (global)" })
