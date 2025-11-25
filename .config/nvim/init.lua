-- [[ Setting options ]]
--  See `:help vim.opt`
--  NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set <space> as the leader key
--  See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable native EditorConfig support
vim.g.editorconfig = true

-- Encoding
vim.opt.encoding = "utf-8"
if vim.o.encoding ~= "utf-8" then
	vim.opt.termencoding = vim.o.encoding
end

-- Autoset order for file character encodings
vim.opt.fileencodings = "utf-8,cp1251,koi8-r,cp866"

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable persistent undo
vim.opt.undofile = false

-- Disable swapfile
vim.opt.swapfile = false

-- Set highlight on search
vim.opt.hlsearch = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false

-- Set invisible symbols
vim.opt.listchars = {
	eol = "¶",
	extends = "»",
	lead = "·",
	nbsp = "␣",
	precedes = "«",
	space = "·",
	tab = "⇥ ",
	trail = "•",
}

-- Enable break indent
vim.opt.breakindent = true

-- Show wrap symbol
vim.opt.showbreak = "↪ "
vim.opt.breakindentopt = "sbr"

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 2

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
--  See `:help 'confirm'`
vim.opt.confirm = true

-- Enable true color support (must be set before colorscheme)
vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<Up>", "v:count == 0 ? 'gk' : '<Up>'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<Down>", "v:count == 0 ? 'gj' : '<Down>'", { expr = true, silent = true })

-- Allow seamless navigation through line endings
vim.keymap.set("n", "<Right>", function()
	local line_len = vim.fn.col("$") - 1 -- length of the current line (0-based)
	local current_col = vim.fn.col(".") -- current cursor column (1-based)
	if current_col >= line_len then
		return "<CR>0"
	else
		return "l"
	end
end, { expr = true, noremap = true, desc = "Smart right navigation" })

vim.keymap.set("i", "<Right>", function()
	local line_len = vim.fn.col("$") -- Length of current line
	local current_col = vim.fn.col(".") -- Current cursor column
	if current_col >= line_len then -- If at end of line
		return "<Esc>j0i"
	else
		return "<Right>" -- Default right arrow behavior
	end
end, { expr = true, noremap = true, desc = "Smart right navigation (insert mode)" })

vim.keymap.set("n", "<Left>", function()
	if vim.fn.col(".") == 1 then -- If at column 1
		return "k$" -- Move up and go to last column
	else
		return "h" -- Otherwise, move left normally
	end
end, { expr = true, noremap = true, desc = "Smart left navigation" })

vim.keymap.set("i", "<Left>", function()
	if vim.fn.col(".") == 1 then -- If at column 1
		return "<Esc>k$i" -- Exit insert, go up, go to last column, re-enter insert
	else
		return "<Left>" -- Default left arrow behavior
	end
end, { expr = true, noremap = true, desc = "Smart left navigation (insert mode)" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("ironvim-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et
