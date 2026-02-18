---@type vim.lsp.Config
return {
	cmd = { "rumdl", "server" },
	root_markers = {
		".git",
	},
	filetypes = { "markdown" },
}
