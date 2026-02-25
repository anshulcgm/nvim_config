local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local lga_ok, lga_actions = pcall(require, "telescope-live-grep-args.actions")

-- configure telescope
local extensions = {
	fzf = {
		fuzzy = true,
		override_generic_sorter = true,
		override_file_sorter = true,
		case_mode = "smart_case",
	},
}

if lga_ok then
	extensions.live_grep_args = {
		auto_quoting = true,
		mappings = {
			i = {
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
		},
	}
end

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
	extensions = extensions,
})

telescope.load_extension("fzf")
if lga_ok then
	telescope.load_extension("live_grep_args")
end
