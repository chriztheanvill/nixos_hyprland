
-- ============================================================
-- Indent guides (indent-blankline)
-- ============================================================
require("ibl").setup({
    indent = {
        char = "│",   -- caracter de la línea vertical
    },
    scope = {
        enabled = true,   -- resalta el scope actual (como VSCode/Zed)
show_start = false,
show_end   = false,
    },
})
