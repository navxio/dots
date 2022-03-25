-- created by
-- Navdeep Saini <navdeep@mailbox.org>
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.opt.termguicolors = true
vim.o.background = "dark"
vim.g.mapleader = " "
vim.g.sonokai_style = "atlantis"

-- setup treesitter based folds
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1
vim.cmd("set splitright")
vim.cmd("set splitbelow")

vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set expandtab")

-- highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

-- start terminal in insert mode
vim.cmd([[
  augroup terminal
    au TermOpen * startinsert
  augroup END
]])
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- setup lazygit
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true,
})

local my_floating_terminal = Terminal:new({
	direction = "float",
	hidden = true,
	size = 40,
})

function _terminal_toggle()
	my_floating_terminal:toggle()
end

function _lazygit_toggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<c-t>", "<cmd>lua _terminal_toggle()<CR>", { noremap = true, silent = true })

vim.g.nvim_tree_respect_buf_cwd = 1

-- Setup nvim-cmp.
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, {
		{ name = "buffer" },
	}),
})

require("luasnip.loaders.from_vscode").load()

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["tsserver"].setup({
	init_options = require("nvim-lsp-ts-utils").init_options,
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		local ts_utils = require("nvim-lsp-ts-utils")

		-- defaults
		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = false,
			-- import all
			import_all_timeout = 5000, -- ms
			-- lower numbers = higher priority
			import_all_priorities = {
				same_file = 1, -- add to existing import statement
				local_files = 2, -- git files or files with relative path markers
				buffer_content = 3, -- loaded buffer content
				buffers = 4, -- loaded buffer names
			},
			import_all_scan_buffers = 100,
			import_all_select_source = false,
			-- if false will avoid organizing imports
			always_organize_imports = true,
			-- filter diagnostics
			filter_out_diagnostics_by_severity = {},
			filter_out_diagnostics_by_code = {},
			-- inlay hints
			auto_inlay_hints = true,
			inlay_hints_highlight = "Comment",
			inlay_hints_priority = 200, -- priority of the hint extmarks
			inlay_hints_throttle = 150, -- throttle the inlay hint request
			inlay_hints_format = {
				-- format options for individual hint kind
				Type = {},
				Parameter = {},
				Enum = {},
				-- Example format customization for `Type` kind:
				-- Type = {
				--     highlight = "Comment",
				--     text = function(text)
				--         return "->" .. text:sub(2)
				--     end,
				-- },
			},
			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = false,
			watch_dir = nil,
		})

		-- required to fix code action ranges and filter diagnostics
		ts_utils.setup_client(client)

		-- no default maps, so you may want to define some here
		local opts = { silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
	end,
})

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("romgrk/nvim-treesitter-context")
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

	use("famiu/bufdelete.nvim")

	use({ "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" })

	use("sainnhe/sonokai")

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.diagnostics.eslint_d,
					require("null-ls").builtins.formatting.prettierd,
					require("null-ls").builtins.formatting.stylua,
				},
				-- you can reuse a shared lspconfig on_attach callback here
				on_attach = function(client)
					if client.resolved_capabilities.document_formatting then
						vim.cmd([[
                    augroup LspFormatting
                        autocmd! * <buffer>
                        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
                    augroup END
                    ]])
					end
				end,
			})
		end,
	})

	use({
		"abecodes/tabout.nvim",
		config = function()
			require("tabout").setup({})
		end,
		wants = { "nvim-treesitter" },
		after = { "nvim-cmp" },
	})
	use("p00f/nvim-ts-rainbow")
	use({
		"datwaft/bubbly.nvim",
		config = function()
			vim.g.bubbly_palette = {
				background = "#34343c",
				foreground = "#c5cdd9",
				black = "#3e4249",
				red = "#ec7279",
				green = "#a0c980",
				yellow = "#deb974",
				blue = "#6cb6eb",
				purple = "#d38aea",
				cyan = "#5dbbc1",
				white = "#c5cdd9",
				lightgrey = "#57595e",
				darkgrey = "#404247",
			}
			vim.g.bubbly_statusline = {
				"mode",
				"truncate",
				"path",
				"branch",
				"gitsigns",
				"divisor",
				"filetype",
				"progress",
			}
		end,
	})

	-- completion stuff
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-git")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")

	use("jose-elias-alvarez/nvim-lsp-ts-utils")

	use("nathom/filetype.nvim")
	use("saadparwaiz1/cmp_luasnip")
	-- snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	use("editorconfig/editorconfig-vim")
	use("rrethy/nvim-treesitter-endwise")
	require("nvim-treesitter.configs").setup({
		endwise = {
			enable = true,
		},
	})
	use("f-person/git-blame.nvim")

	use({
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup({})
		end,
	})

	use("jeffkreeftmeijer/neovim-sensible")

	use("kyazdani42/nvim-web-devicons")

	use({ "adisen99/apprentice.nvim", requires = { "rktjmp/lush.nvim" } })

	use("machakann/vim-sandwich")

	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup({
				pickers = {
					frecency = {
						theme = "ivy",
					},
					find_files = {
						theme = "ivy",
					},
					live_grep = {
						theme = "ivy",
					},
				},
			})
		end,
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
	})

	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
			require("telescope").load_extension("projects")
		end,
	})

	use("akinsho/toggleterm.nvim")

	use({
		"nvim-treesitter/nvim-treesitter",
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	use("winston0410/commented.nvim")

	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	})

	use("JoosepAlviste/nvim-ts-context-commentstring")

	use("folke/which-key.nvim")
	use("karb94/neoscroll.nvim")
	use("sunjon/shade.nvim")
	use({
		"edeneast/nightfox.nvim",
	})

	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				update_cwd = true,
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
			})
		end,
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end

	require("lush")(require("apprentice").setup({
		plugins = {
			"gitsigns",
			"cmp", -- nvim-cmp
			"lsp",
			"lspsaga",
			"packer",
			"signify",
			"telescope",
			"treesitter",
		},
		langs = {
			"c",
			"rust",
			"html",
			"golang",
			"css",
			"js",
			"markdown",
			"python",
			"typescript",
			"ocaml",
			"jsx",
			"json",
			"ruby",
		},
	}))

	require("bufferline").setup({
		options = {
			separator_style = "slant",
		},
	})

	local function prequire(...)
		local status, lib = pcall(require, ...)
		if status then
			return lib
		end
		return nil
	end

	local luasnip = prequire("luasnip")
	local cmp = prequire("cmp")

	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local check_back_space = function()
		local col = vim.fn.col(".") - 1
		if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
			return true
		else
			return false
		end
	end

	_G.tab_complete = function()
		if cmp and cmp.visible() then
			cmp.select_next_item()
		elseif luasnip and luasnip.expand_or_jumpable() then
			return t("<Plug>luasnip-expand-or-jump")
		elseif check_back_space() then
			return t("<Tab>")
		else
			cmp.complete()
		end
		return ""
	end
	_G.s_tab_complete = function()
		if cmp and cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip and luasnip.jumpable(-1) then
			return t("<Plug>luasnip-jump-prev")
		else
			return t("<S-Tab>")
		end
		return ""
	end

	vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
	vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
	vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
	vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
	vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
	vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

	require("nvim-treesitter.configs").setup({
		ensure_installed = "maintained",
		sync_install = false,
		ignore_install = {},
		context_commentstring = {
			enable = true,
		},
		rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		indent = {
			enable = true,
		},
	})
	require("shade").setup({})

	require("neoscroll").setup()
	vim.cmd("unmap <C-b>")
	vim.cmd("unmap <C-f>")

	require("which-key").setup({})

	-- keybindings
	vim.api.nvim_set_keymap("n", "<leader>rc", ":e ~/.config/nvim/init.lua<cr>", { expr = false })
	vim.api.nvim_set_keymap("n", "<tab>", ":bnext<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<s-tab", ":bprevious<cr>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-n>", ":NvimTreeToggle<cr>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-s>", ":w<cr>", { noremap = false })
	vim.api.nvim_set_keymap("i", "<c-s>", "<esc>:w<cr>a", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>e", ":q!<cr>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-p>", ":Telescope find_files<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>te", ":ToggleTerm<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>tt", ":term<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>uu", ":PackerUpdate<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<C-b>", ":Telescope buffers<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope live_grep<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<esc>", ":noh<return><esc>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<C-a>", ":Telescope projects<CR>", { noremap = false })
	vim.cmd("unmap <c-l>")
	vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", { noremap = false })
	vim.api.nvim_set_keymap("n", "<leader>ps", ":PackerSync<CR>", { noremap = false })
	vim.api.nvim_set_keymap("n", "<c-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

	vim.g.bubbly_tabline = 0

	require("commented").setup({
		keybindings = { n = "<leader>/", v = "<leader>/", nl = "<leader>/" },
	})
	vim.cmd("colorscheme sonokai")
end)
