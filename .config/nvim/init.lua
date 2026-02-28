-- ============================================================================
-- Package Management
-- ============================================================================
--
vim.pack.add({

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/fraeso/xcodedark.nvim" },
	{ src = "https://github.com/bartekjaszczak/gruv-vsassist.nvim" },
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
}, { load = true })

-- ============================================================================
-- Colorschemes
-- ============================================================================
--
require("xcodedark").setup({
	transparent = true,
	integrations = {
		telescope = false,
		nvim_tree = false,
		gitsigns = true,
		bufferline = false,
		incline = false,
		lazygit = false,
		which_key = false,
		notify = true,
		snacks = false,
		blink = true,
	},
	terminal_colors = true,
})

require("gruv-vsassist").setup({
	transparent = true,
	italic_comments = true,
	disable_nvimtree_bg = true,
	color_overrides = {
		vscLineNumber = "#FFFFFF",
	},
})

vim.cmd.colorscheme("gruv-vsassist")

local opt = vim.opt
vim.g.mapleader = " "
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.tabstop = 2
opt.smartindent = true
opt.shiftwidth = 2
opt.swapfile = false
opt.scrolloff = 8
opt.hlsearch = false
opt.cursorcolumn = false
opt.guicursor = ""
opt.termguicolors = true
opt.ignorecase = true
opt.winborder = "bold"
opt.signcolumn = "yes"
opt.undofile = true
opt.incsearch = true

-- ============================================================================
-- LSP Configuration
-- ============================================================================

vim.lsp.enable({ "ruff", "pyrefly", "luals", "rumdl", "rust-analyzer" })
-- vim.diagnostic.config({ virtual_text = false })

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

-- FFF
vim.g.fff = {
	lazy_sync = true,
}
require("fff").setup({
	preview = {
		enabled = false,
	}
})

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
		menu = {
			-- auto_show = true,
			-- border = "rounded",
			-- winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			-- scrollbar = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			treesitter_highlighting = true,
			-- window = {
			-- 	border = "rounded",
			-- 	min_width = 10,
			-- 	max_width = 80,
			-- 	max_height = 30,
			-- 	scrollbar = true,
			-- },
		},
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

require("tiny-inline-diagnostic").setup({
	preset = "powerline",
	options = {
		multilines = {
			enabled = true,
		},
		show_source = {
			enabled = true,
			if_many = true,
		},
		add_messages = {
			display_count = true,
		},
	},
})
vim.diagnostic.config({ virtual_text = false })

-- ============================================================================
-- Keymaps
-- ============================================================================
--
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
keymap("n", "<leader><leader>", vim.lsp.buf.format)

-- Clipboard
keymap("x", "y", [["+y]])
keymap({ "n", "v", "x" }, "<leader>y", '"+y')
keymap({ "n", "v", "x" }, "<leader>p", '"+p')

-- Package management
keymap("n", "<leader>U", "<cmd>lua vim.pack.update()<CR>")

-- File navigation
keymap("n", "ff", function()
	require("fff").find_files()
end)

keymap("n", "f/", function()
	require("fff").live_grep()
end)

keymap("n", "-", "<CMD>Oil<CR>")

-- Select all
keymap("v", "ae", "ggVG")

-- Text editing
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "H", "<gv")
keymap("v", "L", ">gv")

-- Treesitter text objects
local nts_select = require("nvim-treesitter-textobjects.select").select_textobject
local nts_move = require("nvim-treesitter-textobjects.move")

-- Text object selection
keymap({ "x", "o" }, "af", function()
	nts_select("@function.outer", "textobjects")
end)
keymap({ "x", "o" }, "if", function()
	nts_select("@function.inner", "textobjects")
end)
keymap({ "x", "o" }, "ac", function()
	nts_select("@class.outer", "textobjects")
end)
keymap({ "x", "o" }, "ic", function()
	nts_select("@class.inner", "textobjects")
end)

-- Text object navigation (next start)
keymap({ "n", "o" }, "]f", function()
	nts_move.goto_next_start("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "]c", function()
	nts_move.goto_next_start("@class.outer", "textobjects")
end)
keymap({ "n", "o" }, "]l", function()
	nts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
keymap({ "n", "o" }, "]s", function()
	nts_move.goto_next_start("@local.scope", "locals")
end)

-- Text object navigation (next end)
keymap({ "n", "o" }, "]F", function()
	nts_move.goto_next_end("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "]C", function()
	nts_move.goto_next_end("@class.outer", "textobjects")
end)

-- Text object navigation (previous start)
keymap({ "n", "o" }, "[f", function()
	nts_move.goto_previous_start("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "[c", function()
	nts_move.goto_previous_start("@class.outer", "textobjects")
end)

-- Text object navigation (previous end)
keymap({ "n", "o" }, "[F", function()
	nts_move.goto_previous_end("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "[C", function()
	nts_move.goto_previous_end("@class.outer", "textobjects")
end)
