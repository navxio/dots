local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.g.mapleader = ' '

-- setup treesitter based folds
vim.api.nvim_exec(
  [[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
  ]],
  true
)
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- setup lazygit
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit',
  direction = 'float',
  hidden = true })
local my_floating_terminal = Terminal:new({
  direction = 'float',
  hidden = true,
  size = 40
})

function _terminal_toggle ()
  my_floating_terminal:toggle()
end

function _lazygit_toggle ()
  lazygit:toggle()
end

vim.api.nvim_set_keymap('n', '<c-t>', "<cmd>lua _terminal_toggle()<CR>",
{noremap = true, silent = true })

 -- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}

return require('packer').startup(function(use)

  use {'akinsho/bufferline.nvim', requires='kyazdani42/nvim-web-devicons'}
  use 'wbthomason/packer.nvim'

  use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

  use 'p00f/nvim-ts-rainbow'
  use {'datwaft/bubbly.nvim', config = function ()
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
      'mode',

      'truncate',

      'path',
      'branch',
      'gitsigns',

      'divisor',
      'filetype',
      'progress'
    }
  end}

  -- completion stuff
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'


  use 'saadparwaiz1/cmp_luasnip'
  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  use 'f-person/git-blame.nvim'
  use 'svermeulen/vimpeccable'

  use 'jeffkreeftmeijer/neovim-sensible'
  use 'kyazdani42/nvim-web-devicons'

  use {'adisen99/apprentice.nvim', requires = {'rktjmp/lush.nvim'}}

  use 'machakann/vim-sandwich'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }}
  }

  use 'akinsho/toggleterm.nvim'

  use {
    'nvim-treesitter/nvim-treesitter'
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
            'nvim-lua/plenary.nvim'
    },
  }

  use 'winston0410/commented.nvim'

  use 'folke/which-key.nvim'
  use 'karb94/neoscroll.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    config = function () require'nvim-tree'.setup {} end
  }

  use 'steelsojka/pears.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  require('lush')(require('apprentice').setup({
    plugins = {
      'gitsigns',
      'cmp', -- nvim-cmp
      'lsp',
      'lspsaga',
      'packer',
      'signify',
      'telescope',
      'treesitter'
    },
    langs = {
      'c',
      'rust',
      'html',
      'golang',
      'css',
      'js',
      'markdown',
      'python',
      'typescript',
      'ocaml',
      'jsx',
      'json',
      'ruby'
    }

  }))

  require('bufferline').setup{}

  require('pears').setup()

  require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    sync_install = false,
    ignore_install = {},
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
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm'
      },
    },
    indent = {
      enable = true
    }
  }

  require('neoscroll').setup()

  require('which-key').setup {}

  -- vimpeccable keybindings
  local vimp = require('vimp')

  vimp.nnoremap('<leader>rc', ':e ~/.config/nvim/init.lua<cr>')
  vimp.nnoremap('<c-n>', ':NvimTreeToggle<cr>')
  vimp.nnoremap('<c-s>', ':w<cr>')
  vimp.inoremap('<c-s>', '<esc>:w<CR>i')
  vimp.nnoremap('<leader>e', ':q!<cr>')
  vimp.nnoremap('<c-p>', ':Telescope find_files<CR>')
  vimp.nnoremap('<leader>bd', ':bd<CR>')
  vimp.nnoremap('<leader>tt', ':ToggleTerm<CR>')
  vimp.nnoremap('<leader>uu', ':PackerUpdate<CR>')

  vim.api.nvim_set_keymap('n', '<c-g>', "<cmd>lua _lazygit_toggle()<CR>",
  {noremap = true, silent = true })

  vim.g.bubbly_tabline = 0

  require('telescope').setup {
    pickers = {
      find_files = {
        theme = 'ivy'
      }
    }
  }

  require('commented').setup {
    keybindings = {n = "<leader>c", v="<leader>c", nl="<leader>/"}
  }
end)
