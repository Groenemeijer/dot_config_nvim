
vim.o.shada = ""
vim.g.mapleader = " "
vim.o.shell = vim.env.SHELL or "/bin/sh"

-- 1. Bootstrapper for all essential plugins
local function ensure_plugin(name, url)
	local data_path = vim.fn.stdpath("data") .. "/site/pack/mini/start/"
	local install_path = data_path .. name
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		print("Installing " .. name .. "...")
		vim.fn.system({ "git", "clone", "--depth=1", url, install_path })
		vim.cmd("packadd " .. name)
	end
end

-- List your plugins here
ensure_plugin("mini.nvim", "https://github.com/echasnovski/mini.nvim")
ensure_plugin("nord.nvim", "https://github.com/shaunsingh/nord.nvim")
ensure_plugin("toggleterm.nvim", "https://github.com/akinsho/toggleterm.nvim")
ensure_plugin("gitsigns.nvim", "https://github.com/lewis6991/gitsigns.nvim")
ensure_plugin("conform.nvim", "https://github.com/stevearc/conform.nvim")
ensure_plugin("rainbow_csv", "https://github.com/mechatroner/rainbow_csv")
ensure_plugin("render-markdown.nvim", "https://github.com/MeanderingProgrammer/render-markdown.nvim")
ensure_plugin("nvim-treesitter", "https://github.com/nvim-treesitter/nvim-treesitter")
ensure_plugin("headlines", "https://github.com/lukas-reineke/headlines.nvim")
ensure_plugin("bufferline", "https://github.com/akinsho/nvim-bufferline.lua")

-- Configure render-markdown
require("render-markdown").setup({
    -- The plugin automatically toggles between raw and rendered views based on mode
    -- Additional options can be added here (padding, borders, etc.)
})

-- 3. Mini.nvim plugin setups
require("mini.basics").setup()
require("mini.bracketed").setup()
require("mini.bufremove").setup()
--require("mini.clue").setup()
require("mini.comment").setup()
require("mini.completion").setup()
require("mini.cursorword").setup()
require("mini.doc").setup()
require("mini.extra").setup()
require("mini.files").setup()
require("mini.fuzzy").setup()
require("mini.hues").setup({
	background = "#232136",
	foreground = "#e0def4",
})
require("mini.indentscope").setup({ symbol = "│" })
require("mini.jump").setup()
--require("mini.jump2d").setup()
require("mini.map").setup()
require("mini.misc").setup()
require("mini.move").setup()
require("mini.notify").setup()
require("mini.operators").setup()
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.sessions").setup()
require("mini.splitjoin").setup()
require("mini.starter").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.test").setup()
require("mini.trailspace").setup()
require("mini.visits").setup()
require("mini.git").setup()
require("mini.ai").setup()
require("mini.animate").setup()
require("mini.diff").setup()
require("mini.deps").setup()
require("mini.align").setup()

-- 4. Togleterm configuration
require("toggleterm").setup({
	direction = "horizontal",
	size = 15,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	close_on_exit = true,
	shell = vim.o.shell,
})

-- 5. Conform.nvim: general code formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		sh = { "shfmt" },
		json = { "jq" },
		javascript = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		jinja = { "prettier" },
		toml = { "prettier" },
		php = { "prettier" },
		go = { "prettier" },
		rust = { "prettier" },
		xml = { "prettier" },
		-- Add more as needed
	},
})

require("headlines").setup({
    markdown = {
        headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
        },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        quote_highlight = "Quote",
    },
})


local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- Marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
})

-- mini.icons configuration
require('mini.icons').setup({
  -- Choose between 'glyph' (default) or 'ascii'
  style = 'glyph',
  -- Override icons per category.  For example, customise some LSP icons:
  lsp = {
    Class    = '', -- new icon for classes
    Function = '󰡱', -- new icon for functions
    Variable = '󰆧', -- new icon for variables
    Keyword  = '󰌋',
  },
  -- Override filetype icons (add or change only what you need)
  filetype = {
    markdown = { icon = '󰍔', hl = 'MiniNormal' },
    lua      = { icon = '󰢱', hl = 'MiniNormal' },
  },
  -- Optional: restrict which extensions will be considered during file resolution
  use_file_extension = function(ext, _)
    return ext ~= 'bak'  -- don’t assign icons for .bak files
  end,
})


local highlights = require("nord").bufferline.highlights({
    italic = true,
    bold = true,
})

require("bufferline").setup({
    options = {
        separator_style = "slant",
    },
    highlights = highlights,
})


vim.keymap.set("n", "<leader>F", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- 6. Toggleterm: <leader>tt to toggle terminal
vim.keymap.set("n", "<leader>tt", function()
	require("toggleterm").toggle(1)
end, { desc = "Toggle bottom terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { buffer = 0 })
		vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { buffer = 0 })
		vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { buffer = 0 })
		vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { buffer = 0 })
	end,
})

-- 7. Gitsigns
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})

-- 8. Colorscheme: Nord
vim.cmd.colorscheme("nord")

-- 9. UI tweaks
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#2e3440", bg = "#88c0d0", bold = true })
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#434c5e", nocombine = true })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#343948" })
vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#343948" })


-- 10. MiniFiles, MiniPick, and navigation keymaps
local keymap = vim.keymap.set
local pick = require("mini.pick")
local files = require("mini.files")

keymap("n", "<leader>e", function()
	files.open()
end, { desc = "Open MiniFiles file manager" })
keymap("n", "<leader>ff", function()
	pick.builtin.files()
end, { desc = "Fuzzy Find Files" })
keymap("n", "<leader>fb", function()
	pick.builtin.buffers()
end, { desc = "Fuzzy Find Buffers" })
keymap("n", "<leader>fg", function()
	pick.builtin.grep_live()
end, { desc = "Live Grep in Files" })
keymap("n", "<leader>fr", function()
	pick.builtin.oldfiles()
end, { desc = "Recent Files" })
keymap("n", "<leader>fh", function()
	pick.builtin.help()
end, { desc = "Fuzzy Help Tags" })
keymap("n", "<leader>fm", function()
	pick.builtin.marks()
end, { desc = "Fuzzy Find Marks" })
keymap("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })

-- 11. Auto open MiniFiles on start with directory
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function(data)
		if vim.fn.isdirectory(data.file) == 1 then
			require("mini.files").open(data.file)
			vim.cmd("stopinsert")
		end
	end,
})

-- 12. Recommended Neovim UI options
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.updatetime = 200
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = true

-- 13. Window navigation in normal mode
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- 14. CleanFile: removes BOM, sets unix line endings, removes quotes and whitespace
local function CleanFile()
	vim.bo.bomb = false
	vim.bo.fileformat = "unix"
	vim.cmd([[silent! %s/\"//g]])
	vim.cmd([[silent! %s/\s\+//g]])
end
keymap("n", "<leader>cf", CleanFile, { desc = "Clean current file" })
keymap("n", "<F4>", CleanFile, { desc = "Clean current file" })

-- 15. ToggleListchars: toggles list mode and sets listchars
local function ToggleListchars()
	if vim.o.list then
		vim.o.list = false
	else
		vim.o.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"
		vim.o.list = true
	end
end
keymap("n", "<leader>tl", ToggleListchars, { desc = "Toggle listchars" })

-- 16. File info popup
local function show_file_info()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	local filetype = vim.bo[buf].filetype
	local encoding = vim.bo[buf].fileencoding ~= "" and vim.bo[buf].fileencoding or vim.o.encoding
	local bom = vim.bo[buf].bomb and "Yes" or "No"
	local fileformat = vim.bo[buf].fileformat
	local lines = vim.api.nvim_buf_line_count(buf)
	local col = vim.fn.col(".")
	local msg = table.concat({
		"Path: " .. (name ~= "" and name or "[No Name]"),
		"Filetype: " .. filetype,
		"Encoding: " .. encoding,
		"BOM: " .. bom,
		"Line endings: " .. fileformat,
		"Lines: " .. lines,
		"Column: " .. col,
	}, "\n")
	vim.notify(msg, vim.log.levels.INFO, { title = "Current File Info" })
end
keymap("n", "<leader>fi", show_file_info, { desc = "Show current file info" })

-- 18. Update all plugins: command to update all git-based plugins
local function update_plugins()
	local start_path = vim.fn.stdpath("data") .. "/site/pack/mini/start/"
	for _, dir in ipairs(vim.fn.glob(start_path .. "*", 1, 1)) do
		if vim.fn.isdirectory(dir .. "/.git") == 1 then
			print("Updating " .. dir)
			vim.fn.system({ "git", "-C", dir, "pull", "--ff-only" })
		end
	end
	print("All plugins updated.")
end
vim.api.nvim_create_user_command("UpdatePlugins", update_plugins, {})

-- 17. Copilot: disable auto-insert/tab accept
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-g>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })

-- 19. Buffer navigation: <Tab> and <S-Tab> to switch buffers
vim.keymap.set('n', '<Tab>',     ':bnext<CR>',     { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>',   ':bprevious<CR>', { desc = 'Previous buffer' })

-- Mappings to toggle rendered view
vim.keymap.set("n", "<leader>rm", function()
    require("render-markdown").toggle()
end, { desc = "Toggle rendered Markdown view" })
-- Trim all trailing whitespace in the current buffer
vim.keymap.set("n", "<leader>ts", function()
  require("mini.trailspace").trim()
end, { desc = "Trim trailing whitespace" })

-- Trim trailing empty lines at end of file
vim.keymap.set("n", "<leader>te", function()
  require("mini.trailspace").trim_last_lines()
end, { desc = "Trim trailing empty lines" })

