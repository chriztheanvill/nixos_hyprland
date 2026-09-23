local map              = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

-- ============================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================
local dap              = require("dap")
local dapui            = require("dapui")

-- -- Configuración con LLDB (lldb-vscode / lldb-dap)
-- -- Requiere: llvm  →  dnf install llvm  /  pacman -S llvm
-- -- El binario puede llamarse lldb-vscode o lldb-dap según la versión
dap.adapters.lldb      = {
  type    = "executable",
  command = vim.fn.exepath("lldb-dap"),
  name    = "lldb",
}

-- Configuración con GDB
-- Requiere: gdb  →  dnf install gdb  /  pacman -S gdb
dap.adapters.gdb       = {
  type          = "executable",
  command       = "gdb",
  args          = { "-i", "dap" },
  name          = "gdb",
  -- forzar que GDB acepte breakpoints antes de cargar el binario
  enrich_config = function(config, on_config)
    local final = vim.deepcopy(config)
    final.stopAtBeginningOfMainSubprogram = false
    on_config(final)
  end,
}

dap.configurations.zig = {
  {
    name         = "Zig: debug (lldb)",
    type         = "lldb",
    request      = "launch",
    program      = function()
      -- busca el binario compilado con zig build
      return vim.fn.input("Ejecutable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
    end,
    cwd          = "${workspaceFolder}",
    stopOnEntry  = false,
    args         = {},
    -- runInTerminal = true, -- da error en nixos
    initCommands = {
      'command script import pretty_printers.py',
      'type category enable zig.lang zig.std zig',
    },
  },
  {
    name                            = "Zig: debug (gdb)",
    type                            = "gdb",
    request                         = "launch",
    program                         = function()
      return vim.fn.input("Ejecutable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
    end,
    cwd                             = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    setupCommands                   = {
      {
        text = "set breakpoint pending on",
        description = "Permite breakpoints en DLLs no cargadas aún (hot-reload)",
        ignoreFailures = false,
      },
      {
        text = "set print object on",
        description = "Pretty printing",
        ignoreFailures = true,
      },
    },
  },

}

-- Las mismas configs sirven para C/C++ — reusar el adapter gdb
dap.configurations.c   = dap.configurations.zig
dap.configurations.cpp = dap.configurations.zig

-- ============================================================
-- DAP UI
-- ============================================================
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  layouts = {
    {
      -- Panel lateral izquierdo: scopes, watches, breakpoints, stacks
      elements = {
        { id = "scopes",      size = 0.35 },
        { id = "watches",     size = 0.25 },
        { id = "breakpoints", size = 0.20 },
        { id = "stacks",      size = 0.20 },
      },
      size     = 40,
      position = "left",
    },
    {
      -- Panel inferior: REPL y consola
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size     = 12,
      position = "bottom",
    },
  },
  floating = {
    border   = "rounded",
    mappings = { close = { "q", "<Esc>" } },
  },
})

-- Abrir/cerrar UI automáticamente al iniciar/terminar sesión DAP
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

-- Keymaps DAP
map("<F5>", dap.continue, "DAP: continuar / iniciar")
map("<F6>", dap.pause, "DAP: pausar")
map("<F7>", dap.restart, "DAP: restart")
map("<F8>", dap.terminate, "DAP: terminar")
map("<F10>", dap.step_over, "DAP: step over")
map("<F11>", dap.step_into, "DAP: step into")
map("<F12>", dap.step_out, "DAP: step out")
map("<leader>db", dap.toggle_breakpoint, "DAP: toggle breakpoint")
map("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condición: "))
end, "DAP: breakpoint condicional")
map("<leader>dr", dap.repl.open, "DAP: abrir REPL")
map("<leader>dl", dap.run_last, "DAP: re-ejecutar último")
map("<leader>du", dapui.toggle, "DAP: toggle UI")
map("<leader>de", function()
  dapui.eval(nil, { enter = true })
end, "DAP: evaluar expresión bajo cursor")
