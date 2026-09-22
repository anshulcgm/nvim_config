local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

local function on_attach(bufnr)
	local api = require("nvim-tree.api")
	api.map.on_attach.default(bufnr)
	vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", {
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
