vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range('*')},
	{ src = "https://github.com/saghen/blink.indent"},
	{ src = "https://github.com/0xleodevv/oc-2.nvim" },
	{ src = "https://github.com/rose-pine/neovim"},
	-- { src = "https://github.com/fraeso/xcodedark.nvim" },
	-- { src = "https://github.com/ydkulks/cursor-dark.nvim" },
	-- { src = "https://github.com/mrpbennett/boo-berry.nvim"},
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
}, { load = true })

vim.cmd.colorscheme("rose-pine-dawn")

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
opt.cursorline = true
opt.guicursor = ""
opt.termguicolors = true
opt.ignorecase = true
opt.undofile = true
opt.incsearch = true
opt.winborder = "rounded"

vim.lsp.enable({ "ruff", "pyrefly", "luals", "rumdl", "rust-analyzer" })

local autocmd = vim.api.nvim_create_autocmd

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

autocmd("PackChanged", {
	callback = function(event)
		if event.data.updated then
			require("fff.download").download_or_build_binary()
		end
	end,
})

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

vim.g.fff = {
	lazy_sync = true,
}
require("fff").setup({
	preview = {
		enabled = false,
	},
})

local parsers = { "lua", "python", "rust" }
local nts = require("nvim-treesitter")
nts.setup()
nts.install(parsers)

require("blink.cmp").setup()
require('blink.indent').setup({})

require("oil").setup({
	keymaps = {
		["l"] = { "actions.select", mode = "n" },
		["h"] = { "actions.parent", mode = "n" },
	},
	view_options = { show_hidden = true },
})


require("tiny-inline-diagnostic").setup({
	preset = "minimal",
	options = {
		show_source = {
			enabled = true,
		},
	},
})
vim.diagnostic.config({ virtual_text = false })

local keymap = vim.keymap.set
keymap("n", "<leader>r", ":update<CR> :so<CR>")
keymap("i", "jk", "<Esc>")
keymap("i", "kj", "<Esc>")

keymap("n", "sv", "<cmd>vsplit<CR>")
keymap("n", "ss", "<cmd>split<CR>")
keymap("n", "sd", "<cmd>close<CR>")

keymap("n", "sh", "<C-w>h")
keymap("n", "sk", "<C-w>k")
keymap("n", "sj", "<C-w>j")
keymap("n", "sl", "<C-w>l")

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

keymap("n", "<leader><leader>", vim.lsp.buf.format)

keymap("x", "y", [["+y]])
keymap({ "n", "v", "x" }, "<leader>y", '"+y')
keymap({ "n", "v", "x" }, "<leader>p", '"+p')

keymap("n", "<leader>U", "<cmd>lua vim.pack.update()<CR>")

keymap("n", "ff", function()
	require("fff").find_files()
end)

keymap("n", "f/", function()
	require("fff").live_grep()
end)

keymap("n", "-", "<CMD>Oil<CR>")

keymap("n", "vae", "ggVG")

keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "H", "<gv")
keymap("v", "L", ">gv")

local nts_select = require("nvim-treesitter-textobjects.select").select_textobject
local nts_move = require("nvim-treesitter-textobjects.move")

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
keymap({ "n", "o" }, "]F", function()
	nts_move.goto_next_end("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "]C", function()
	nts_move.goto_next_end("@class.outer", "textobjects")
end)

keymap({ "n", "o" }, "[f", function()
	nts_move.goto_previous_start("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "[c", function()
	nts_move.goto_previous_start("@class.outer", "textobjects")
end)
keymap({ "n", "o" }, "[F", function()
	nts_move.goto_previous_end("@function.outer", "textobjects")
end)
keymap({ "n", "o" }, "[C", function()
	nts_move.goto_previous_end("@class.outer", "textobjects")
end)
