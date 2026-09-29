-- ~/.config/nvim/lua/godot.lua
local M = {}

local cfg = {
	host = "127.0.0.1",
	port = 6005,
	indent_spaces = 2, -- nil = tabs (lo que usa gdformat por defecto)
}

local function format_buffer(buf)
	if vim.fn.executable("gdformat") == 0 then return end

	local cmd = { "gdformat" }
	if cfg.indent_spaces then
		table.insert(cmd, "--use-spaces=" .. cfg.indent_spaces)
	end
	table.insert(cmd, "-")

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local res = vim.system(cmd, {
		stdin = table.concat(lines, "\n") .. "\n",
		text = true,
	}):wait(3000)

	if res.code ~= 0 then
		vim.notify("gdformat: " .. (res.stderr or ""), vim.log.levels.WARN)
		return -- con error de sintaxis no toca el buffer
	end

	local out = vim.split(res.stdout, "\n", { plain = true })
	if out[#out] == "" then table.remove(out) end

	if not vim.deep_equal(out, lines) then
		local view = vim.fn.winsaveview()
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
		vim.fn.winrestview(view)
	end
end

function M.setup(opts)
	cfg = vim.tbl_extend("force", cfg, opts or {})

	-- LSP (Godot debe estar abierto con el proyecto)
	vim.lsp.config("gdscript", {
		cmd = vim.lsp.rpc.connect(cfg.host, cfg.port),
		filetypes = { "gdscript" },
		root_markers = { "project.godot", ".git" },
	})
	vim.lsp.enable("gdscript")

	local group = vim.api.nvim_create_augroup("GodotConfig", { clear = true })

	-- Indentación: debe coincidir con la de gdformat y con la del editor de Godot
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "gdscript",
		callback = function()
			local n = cfg.indent_spaces
			vim.bo.expandtab = n ~= nil
			vim.bo.tabstop = n or 4
			vim.bo.shiftwidth = n or 4
			vim.bo.softtabstop = n or 4
		end,
	})

	-- Formato al guardar
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = "*.gd",
		callback = function(args) format_buffer(args.buf) end,
	})
end

return M
