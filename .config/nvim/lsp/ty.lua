---@type vim.lsp.Config
return {
	cmd = { "ty", "server" },
	root_markers = {
		"ty.toml",
		"pyproject.toml",
		".git",
	},
	filetypes = { "python" },
	settings = {
		ty = {
			experimental = {
				rename = true,
			},
		},
	},
}
