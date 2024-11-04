local setup, auto_save = pcall(require, "auto-save")

if not setup then
	return
end

auto_save.setup()
