-- created by
-- Navdeep Saini <navdeep@mailbox.org>
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

vim.opt.termguicolors = true
vim.o.background = "dark"
vim.g.mapleader = " "

-- setup treesitter based folds
vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set splitright")
vim.cmd("set splitbelow")
-- format on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.jsx,*.js,*.rs,*.lua FormatWrite
augroup END
]],
  true
)

-- setup lazygit
local Terminal = require("toggleterm.terminal").Terminal
local lazygit =
  Terminal:new(
  {
    cmd = "lazygit",
    direction = "float",
    hidden = true
  }
)

local my_floating_terminal =
  Terminal:new(
  {
    direction = "float",
    hidden = true,
    size = 40
  }
)

function _terminal_toggle()
  my_floating_terminal:toggle()
end

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<c-t>", "<cmd>lua _terminal_toggle()<CR>", {noremap = true, silent = true})

vim.g.nvim_tree_respect_buf_cwd = 1

-- Setup nvim-cmp.
local cmp = require "cmp"

cmp.setup(
  {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end
    },
    mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping(
        {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close()
        }
      ),
      ["<CR>"] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources(
      {
        {name = "nvim_lsp"},
        {name = "luasnip"} -- For luasnip users.
      },
      {
        {name = "buffer"}
      }
    )
  }
)

require("luasnip.loaders.from_vscode").load()

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/",
  {
    sources = {
      {name = "buffer"}
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  {
    sources = cmp.config.sources(
      {
        {name = "path"}
      },
      {
        {name = "cmdline"}
      }
    )
  }
)

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["tsserver"].setup {
  capabilities = capabilities
}

return require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim"
    use "romgrk/nvim-treesitter-context"
    use {"akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons"}

    use {"rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins"}

    use "p00f/nvim-ts-rainbow"
    use {
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
          darkgrey = "#404247"
        }
        vim.g.bubbly_statusline = {
          "mode",
          "truncate",
          "path",
          "branch",
          "gitsigns",
          "divisor",
          "filetype",
          "progress"
        }
      end
    }

    -- completion stuff
    use "neovim/nvim-lspconfig"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"

    use "nathom/filetype.nvim"
    use "saadparwaiz1/cmp_luasnip"
    -- snippets
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"

    use "f-person/git-blame.nvim"
    use "svermeulen/vimpeccable"

    use {
      "folke/twilight.nvim",
      config = function()
        require("twilight").setup {}
      end
    }

    use {
      "mhartington/formatter.nvim",
      config = function()
        require("formatter").setup(
          {
            filetype = {
              javascript = {
                function()
                  return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
                    stdin = true
                  }
                end
              },
              json = {
                function()
                  return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
                    stdin = true
                  }
                end
              },
              javascriptreact = {
                function()
                  return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
                    stdin = true
                  }
                end
              },
              python = {
                function()
                  return {
                    exe = "black",
                    args = {"-"},
                    stdin = true
                  }
                end
              },
              lua = {
                function()
                  return {
                    exe = "luafmt",
                    args = {"--indent-count", 2, "--stdin"},
                    stdin = true
                  }
                end
              }
            }
          }
        )
      end
    }

    use "jeffkreeftmeijer/neovim-sensible"
    use "kyazdani42/nvim-web-devicons"

    use {"adisen99/apprentice.nvim", requires = {"rktjmp/lush.nvim"}}

    use "machakann/vim-sandwich"

    use {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("telescope").setup {
          pickers = {
            frecency = {
              theme = "ivy"
            },
            find_files = {
              theme = "ivy"
            },
            live_grep = {
              theme = "ivy"
            }
          }
        }
      end,
      requires = {{"nvim-lua/plenary.nvim"}}
    }

    use {
      "nvim-telescope/telescope-frecency.nvim",
      config = function()
        require("telescope").load_extension("frecency")
      end,
      requires = {"tami5/sqlite.lua"}
    }

    use {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup {}
        require("telescope").load_extension("projects")
      end
    }

    use "akinsho/toggleterm.nvim"

    use {
      "nvim-treesitter/nvim-treesitter"
    }
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      }
    }

    use "winston0410/commented.nvim"

    use {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end
    }

    use "JoosepAlviste/nvim-ts-context-commentstring"

    use "folke/which-key.nvim"
    use "karb94/neoscroll.nvim"
    use "sunjon/shade.nvim"
    use {
      "edeneast/nightfox.nvim",
      config = function()
        require("nightfox").load("nordfox")
      end
    }

    use {
      "kyazdani42/nvim-tree.lua",
      config = function()
        require "nvim-tree".setup {
          update_cwd = true,
          update_focused_file = {
            enable = true,
            update_cwd = true
          }
        }
      end
    }

    use "steelsojka/pears.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end

    require("lush")(
      require("apprentice").setup(
        {
          plugins = {
            "gitsigns",
            "cmp", -- nvim-cmp
            "lsp",
            "lspsaga",
            "packer",
            "signify",
            "telescope",
            "treesitter"
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
            "ruby"
          }
        }
      )
    )

    require("bufferline").setup {
      separator_style = "padded_slant"
    }

    require("pears").setup()
    local function prequire(...)
      local status, lib = pcall(require, ...)
      if (status) then
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
        return t "<Tab>"
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
        return t "<S-Tab>"
      end
      return ""
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
    vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

    require "nvim-treesitter.configs".setup {
      ensure_installed = "maintained",
      sync_install = false,
      ignore_install = {},
      context_commentstring = {
        enable = true
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm"
        }
      },
      indent = {
        enable = true
      }
    }
    require("shade").setup({})

    require("neoscroll").setup()
    vim.cmd("unmap <C-b>")
    vim.cmd("unmap <C-f>")

    require("which-key").setup {}

    -- vimpeccable keybindings
    local vimp = require("vimp")

    vimp.nnoremap("<leader>rc", ":e ~/.config/nvim/init.lua<cr>")
    vimp.nnoremap("<c-n>", ":NvimTreeToggle<cr>")
    vimp.nnoremap("<c-s>", ":w<cr>")
    vimp.inoremap("<c-s>", "<esc>:w<CR>i")
    vimp.nnoremap("<leader>e", ":q!<cr>")
    vimp.nnoremap("<c-p>", ":Telescope find_files<CR>")
    vimp.nnoremap("<leader>bd", ":bd<CR>")
    vimp.nnoremap("<leader>tt", ":ToggleTerm<CR>")
    vimp.nnoremap("<leader>uu", ":PackerUpdate<CR>")
    vimp.nnoremap("<C-b>", ":Telescope buffers<CR>")
    vimp.nnoremap("<C-f>", ":Telescope live_grep<CR>")
    vimp.nnoremap("<esc>", ":noh<return><esc>")
    vimp.nnoremap("<C-a>", ":Telescope projects<CR>")
    vim.cmd("unmap <c-l>")
    vimp.nnoremap("<c-h>", "<c-w>h")
    vimp.nnoremap("<c-l>", "<c-w>l")
    vimp.nnoremap("<c-j>", "<c-w>j")
    vimp.nnoremap("<c-k>", "<c-w>k")
    -- vimp.nnoremap('<esc>^[', '<esc>^[')

    vim.api.nvim_set_keymap("n", "<c-g>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

    vim.g.bubbly_tabline = 0

    require("commented").setup {
      keybindings = {n = "<leader>/", v = "<leader>/", nl = "<leader>/"}
    }
  end
)
