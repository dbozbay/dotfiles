---@type vim.lsp.Config
return {
	cmd = { "pyrefly", "lsp" },
	root_markers = {
		"pyrefly.toml",
		"pyproject.toml",
		".git",
	},
	settings = {
		python = {
			pyrefly = {
				displayTypeError = "force-on",
			},
		},
	},
	filetypes = { "python" },
	on_exit = function(code, _, _)
		vim.notify("Closing Pyrefly LSP exited with code: " .. code, vim.log.levels.INFO)
	end,
}
