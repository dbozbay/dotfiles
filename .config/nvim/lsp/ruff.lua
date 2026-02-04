---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	root_markers = {
		"pyproject.toml",
		"ruff.toml",
		".ruff.toml",
	},
	filetypes = { "python" },
}
