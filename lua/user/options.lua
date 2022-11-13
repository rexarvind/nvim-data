
-- use local variable for vim options
local o = vim.opt


o.backup = false  -- creates a backup file
o.clipboard = "unnamedplus"  -- allows neovim to access system clipboard
o.cmdheight = 1  -- more space in neovim command line for displaying messages
o.completeopt = { "menuone", "noselect" }  -- mostly just for cmp
o.conceallevel = 0  -- so that `` is visible in markdown files
o.fileencoding = "utf-8"  -- encoding written to a file
o.hlsearch = true  -- highlight all matches on previous search pattern
o.ignorecase = true  -- ignore case in search patterns
o.mouse = "a"  -- allow the mouse to be used in neovim
o.pumheight = 10  -- pop up menu height
o.showmode = false  -- no need to show current mode like -- INSERT -- because using LuaLine plugin
o.showtabline = 0  -- always show tabs
o.smartcase = true  -- smart case
o.smartindent = true  -- make indenting smarter again
o.splitbelow = true  -- force all horizontal splits to go below current window
o.splitright = true  -- force all vertical splits to go to right of current window
o.swapfile = false  -- creates a swap file
o.termguicolors = true  -- set terminal gui colors (most terminals support this)
o.timeoutlen = 1000  -- time to wait for mapped sequence to complete (in milliseconds)
o.undofile = true  -- enable persistent undo
o.updatetime = 300  -- faster completions (4000ms default)
o.writebackup = false  -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
-- o.autoindent = true  -- indendt new line the same amount as the line just typed
o.expandtab = true  -- convert tabs to spaces
o.shiftwidth = 4  -- number of spaces inserted for each indentation
o.tabstop = 4  -- number of spaces for TAB key
-- o.softtabstop = 4  -- see multiple space as tabstops so <BS> does the right thing
-- o.retab = 4  -- change tabs to 2 for new files
o.cursorline = true  -- highlight current line of text cursor
o.cursorcolumn = false  -- highlight current column of text curson
o.number = true  -- set numbered lines
o.relativenumber = true -- relative line number
o.laststatus = 3  -- only the last window will always have a status line
o.showcmd = false  -- hide (partial) command in the last line of the screen (for performance)
o.ruler = false  -- hide the line and column number of the cursor position
o.numberwidth = 3  -- minimal number of columns to use for the line number (default 4)
o.signcolumn = "yes"  -- always show the sign column, otherwise it would shift the text each time
o.wrap = false  -- display lines as one long line
o.scrolloff = 4  -- minimum number of screen lines to keep above and below the cursor
o.sidescrolloff = 4  -- minimum number of screen lines columns to keep to left and right of the cursor if warp is `false`
o.guifont = "FiraCode NFM:h11"  -- the font used in graphical neovim applications
-- o.guioptions+=b  -- set horizontal scrollbar
o.fillchars.eob=" "  -- show empty lines at the end of a buffer as ` ` (default is `-`)
o.shortmess:append "c"  -- hide all the completion messages, e.g. "-- xxx completion (yyy)", "match 1 of 2", "The only watch", "Pattern not found"
o.whichwrap:append("<,>,[,],h,l")  -- keys allowed to move to the previous/next line when the beginning/end of the line is reached
o.iskeyword:append("-")  -- treats words with `-` as single words


o.list = true
o.listchars:append "space:⋅"
-- o.listchars:append "eol:↴"

vim.cmd "map q <Nop>" -- disable macro recording

-- use vim.cmd to vim commands as it is
-- vim.cmd "set number"

