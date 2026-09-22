local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

local function navigate_right()
	local current_win = vim.api.nvim_get_current_win()
	local has_editor_window = false

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if win ~= current_win and vim.api.nvim_win_get_config(win).relative == "" then
			has_editor_window = true
			break
		end
	end

	if has_editor_window then
		vim.cmd("TmuxNavigateRight")
	else
		vim.cmd("vnew")
	end
end

local function on_attach(bufnr)
	local api = require("nvim-tree.api")
	api.map.on_attach.default(bufnr)
	vim.keymap.set("n", "<C-l>", navigate_right, {
		buffer = bufnr,
		desc = "Navigate right",
		noremap = true,
		silent = true,
	})
end

-- recommended settings from nvim-tree documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- configure nvim-tree
nvimtree.setup({
	on_attach = on_attach,
	-- change folder arrow icons
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- arrow when folder is closed
					arrow_open = "", -- arrow when folder is open
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	filters = {
		dotfiles = false,
	},
})
