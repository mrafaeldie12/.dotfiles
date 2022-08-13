vim.notify('Hello from the other side init.lua')

vim.g.mapleader = ","
vim.g.maplocalleader = ","

require('packer').startup(function() 
    use 'wbthomason/packer.nvim'
    use "ellisonleao/gruvbox.nvim" 
    use 'neovim/nvim-lspconfig'
    use 'tridactyl/vim-tridactyl'
    use 'mbbill/undotree'
    use 'dracula/vim'
    use 'direnv/direnv'
    use 'tpope/vim-commentary'
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-fugitive'
    use {
	'junegunn/fzf',
	run = 'fzf#install()'
    }
    use 'junegunn/fzf.vim'
    use 'ferrine/md-img-paste.vim'
    use 'godlygeek/tabular'
    use 'preservim/vim-markdown'
    use({
    	'iamcco/markdown-preview.nvim',
        run = function() vim.fn['mkdp#util#install']() end,
    })
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'drewtempelmeyer/palenight.vim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'mhartington/oceanic-next'
    use 'echasnovski/mini.nvim'
    use 'L3MON4D3/LuaSnip'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
	'nvim-telescope/telescope.nvim',
  	requires = {
		{'nvim-lua/plenary.nvim'}
	}
   }
end)

vim.o.number = true
vim.o.relativenumber = true

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "<Esc>", "<nop>")

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")

arrowKeys = {"<Up>", "<Down>", "<Left>", "<Right>"}

for key, value in pairs(arrowKeys) do
	vim.keymap.set({"n", "v"}, value, "<nop>")
end

local lsp = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

require('mini.surround').setup({})
require('nvim-autopairs').setup({})

vim.keymap.set("n", "<leader>h", ":noh<CR>")
vim.keymap.set("n", "<leader>tn", ":set rnu!<CR>")

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")

vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>")

vim.keymap.set("n", "<leader>gy", ":Goyo<CR>")

vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>")

local on_attach = function(client, bufnr)
	local opts = { noremap = true,
	               silent  = true,
	               buffer = bufnr }

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.gopls.setup({
	name = "gopls",
	cmd = {"gopls", "--remote=auto", "serve"},
	init_options = {
		gofumpt = true,
		staticcheck = true,
		memoryMode = "DegradeClosed"
	},
	whitelist = {"go"},
	capabilities = capabilities,
	on_attach = on_attach
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	preselect = cmp.PreselectMode.None,
	mapping = cmp.mapping.preset.insert({
              ['<c-b>'] = cmp.mapping.scroll_docs(-4),
              ['<c-f>'] = cmp.mapping.scroll_docs(4),
              ['<tab>'] = cmp.mapping.select_next_item(),
              ['<s-tab>'] = cmp.mapping.select_prev_item(),
              ['<c-space>'] = cmp.mapping.complete(),
              ['<c-e>'] = cmp.mapping.abort(),
              ['<cr>'] = cmp.mapping.confirm({select  = true})
        }),
        sources = cmp.config.sources({
              {name = "nvim_lsp"}
	})
})

vim.cmd [[
 set termguicolors
 set incsearch
 set scrolloff=1
 set autoread
 syntax enable
 set background=light
 colorscheme gruvbox
 autocmd! User GoyoEnter Limelight
 autocmd! User GoyoLeave Limelight!
 filetype plugin indent on
 set tabstop=4
 set shiftwidth=4
 set expandtab
 augroup templates
  autocmd BufNewFile *.go 0r ~/.dotfiles/nvim/templates/main.go
 augroup END
]]
