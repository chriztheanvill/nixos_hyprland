-- ~/.config/nvim/lua/godot.lua

--
-- Para que funcione perfectamente:
-- > En godot 4.8
-- - todo tiene que estar en wayland, mejora el debug
-- - en la parte de arriba, hay unas pestanas, seleccionar `game`
--   - arriba a la derecha, hay tres iconos, selecionar el de en medio
--		- `Run game floating window with toolbar`
--

local M = {}

local cfg = {
	host = "127.0.0.1",
	port = 6005,
	indent_spaces = 2,          -- nil = tabs (lo que usa gdformat por defecto)
	autostart_server = true,    -- equivale a `nvim --listen ./server.pipe` dentro de proyectos Godot
	server_pipe = "server.pipe", -- debe coincidir con --server en los Exec Flags de Godot
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

local function start_server()
	local arg = vim.fn.argv(0)
	local start = vim.uv.cwd()
	if arg ~= "" then
		local p = vim.fn.fnamemodify(arg, ":p")
		start = vim.fn.isdirectory(p) == 1 and p or vim.fn.fnamemodify(p, ":h")
	end

	local root = vim.fs.root(start, "project.godot")
	if not root then return end

	local pipe = vim.fs.joinpath(root, cfg.server_pipe)
	if vim.list_contains(vim.fn.serverlist(), pipe) then return end

	if vim.uv.fs_stat(pipe) then
		-- si otro nvim ya escucha ahí, no lo pisamos
		local ok, ch = pcall(vim.fn.sockconnect, "pipe", pipe, { rpc = true })
		if ok and ch > 0 then
			vim.fn.chanclose(ch)
			return
		end
		vim.uv.fs_unlink(pipe) -- socket huérfano de una sesión que murió
	end

	local ok, err = pcall(vim.fn.serverstart, pipe)
	if not ok then
		vim.notify("Godot server: " .. tostring(err), vim.log.levels.WARN)
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

	-- Indentación: debe coincidir con gdformat y con el editor de Godot
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

	-- Servidor para que Godot abra los scripts en esta instancia
	if cfg.autostart_server then
		vim.api.nvim_create_autocmd("VimEnter", { group = group, callback = start_server })
	end
end

return M
