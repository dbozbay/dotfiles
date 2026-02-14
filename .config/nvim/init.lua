vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.tabstop = 2
opt.smartindent = true
opt.shiftwidth = 2
opt.swapfile = false
opt.cursorline = true
opt.scrolloff = 8
opt.hlsearch = false
opt.cursorcolumn = false
opt.guicursor = ""
opt.termguicolors = true
opt.ignorecase = true
opt.winborder = "rounded"
opt.signcolumn = "yes"
opt.undofile = true
opt.incsearch = true

-- ============================================================================
-- LSP Configuration
-- ============================================================================
vim.lsp.enable({ "ruff", "pyrefly", "luals", "clangd", "rust-analyzer" })
vim.diagnostic.config({ virtual_text = true })

-- ============================================================================
-- Autocommands
-- ============================================================================
local autocmd = vim.api.nvim_create_autocmd

-- LSP keymaps on attach
autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
	callback = function(args)
		local map = vim.keymap.set
		local opts = { buffer = args.buf }
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gs", vim.lsp.buf.signature_help, opts)
		map("n", "gh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, opts)
	end,
})

-- Disable Ruff hover (use Pyright instead)
autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

-- FFF binary download on pack update
autocmd("PackChanged", {
	callback = function(event)
		if event.data.updated then
			require("fff.download").download_or_build_binary()
		end
	end,
})

-- Treesitter auto-update
autocmd("PackChanged", {
	callback = function(args)
		local spec = args.data.spec
		if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
			vim.schedule(function()
				require("nvim-treesitter").update()
			end)
		end
	end,
})

-- Treesitter filetype detection
autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if not lang then
			vim.notify("TS cannot determine language.")
			return
		end

		if vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- ============================================================================
-- Package Management
-- ============================================================================
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- { src = "https://github.com/ydkulks/cursor-dark.nvim" },
	{ src = "https://github.com/duarteocarmo/cursor-themes" },
}, { load = true })

-- ============================================================================
-- Colorscheme
-- ============================================================================
vim.cmd.colorscheme("cursor-dark")

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

-- FFF
vim.g.fff = {
	lazy_sync = true,
	debug = {
		enabled = true,
		show_scores = true,
	},
}
require("fff").setup()

-- Treesitter
local parsers = { "lua", "python", "rust" }
local nts = require("nvim-treesitter")
nts.setup()
nts.install(parsers)

-- Oil
require("oil").setup({
	keymaps = {
		["l"] = { "actions.select", mode = "n" },
		["h"] = { "actions.parent", mode = "n" },
	},
	view_options = { show_hidden = true },
})

-- Blink.cmp
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = { nerd_font_variant = "mono" },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	completion = {
		documentation = { auto_show = false },
		menu = {
			border = "none",
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							end
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			},
		},
	},
})

-- Mini.move
require("mini.move").setup({
	mappings = {
		left = "<C-h>",
		right = "<C-l>",
		down = "<C-j>",
		up = "<C-k>",

		line_left = "<C-h>",
		line_right = "<C-l>",
		line_down = "<C-j>",
		line_up = "<C-k>",
	},
})

-- Autopairs
require("nvim-autopairs").setup({})

-- Lualine
require("lualine").setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
})

-- ============================================================================
-- Keymaps
-- ============================================================================
local keymap = vim.keymap.set

-- General
keymap("n", "<leader>r", ":update<CR> :so<CR>")
keymap("i", "jk", "<Esc>")
keymap("i", "kj", "<Esc>")

-- Window splits
keymap("n", "sv", "<cmd>vsplit<CR>")
keymap("n", "ss", "<cmd>split<CR>")
keymap("n", "sd", "<cmd>close<CR>")

-- Navigation
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- LSP
keymap("n", "<leader>ff", vim.lsp.buf.format)

-- Clipboard
keymap("x", "y", [["+y]])
keymap({ "n", "v", "x" }, "<leader>y", '"+y')
keymap({ "n", "v", "x" }, "<leader>p", '"+p')

-- Package management
keymap("n", "<leader>U", "<cmd>lua vim.pack.update()<CR>")

-- File navigation
keymap("n", "<leader><leader>", function()
	require("fff").find_files()
end)
keymap("n", "-", "<CMD>Oil<CR>")

-- Treesitter text objects
local nts_select = require("nvim-treesitter-textobjects.select").select_textobject
local nts_move = require("nvim-treesitter-textobjects.move")

-- Text object selection
keymap("x", "af", function()
	nts_select("@function.outer", "textobjects")
end)
keymap("x", "if", function()
	nts_select("@function.inner", "textobjects")
end)
keymap("x", "ac", function()
	nts_select("@class.outer", "textobjects")
end)
keymap("x", "ic", function()
	nts_select("@class.inner", "textobjects")
end)

-- Text object navigation (next start)
keymap({ "n", "x" }, "]f", function()
	nts_move.goto_next_start("@function.outer", "textobjects")
end)
keymap({ "n", "x" }, "]c", function()
	nts_move.goto_next_start("@class.outer", "textobjects")
end)
keymap({ "n", "x" }, "]l", function()
	nts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
keymap({ "n", "x" }, "]s", function()
	nts_move.goto_next_start("@local.scope", "locals")
end)

-- Text object navigation (next end)
keymap({ "n", "x" }, "]F", function()
	nts_move.goto_next_end("@function.outer", "textobjects")
end)
keymap({ "n", "x" }, "]C", function()
	nts_move.goto_next_end("@class.outer", "textobjects")
end)

-- Text object navigation (previous start)
keymap({ "n", "x" }, "[f", function()
	nts_move.goto_previous_start("@function.outer", "textobjects")
end)
keymap({ "n", "x" }, "[c", function()
	nts_move.goto_previous_start("@class.outer", "textobjects")
end)

-- Text object navigation (previous end)
keymap({ "n", "x" }, "[F", function()
	nts_move.goto_previous_end("@function.outer", "textobjects")
end)
keymap({ "n", "x" }, "[C", function()
	nts_move.goto_previous_end("@class.outer", "textobjects")
end)
