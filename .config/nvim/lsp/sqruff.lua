---@type vim.lsp.Config
return {
	cmd = { "sqruff", "lsp" },
	root_markers = {
		".git",
		"sqruff",
	},
	filetypes = { "sql" },
}
