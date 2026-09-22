-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end

-- enable mason
mason.setup({
  PATH = "append",
})

local ensure_installed = {
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
  "emmet_ls",
  "pylsp",
}

-- Mason does not publish clangd for every platform (notably Linux ARM64).
-- Prefer an available system clangd and let Mason supply it only as a fallback.
if vim.fn.executable("clangd") == 0 then
  table.insert(ensure_installed, "clangd")
end

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = ensure_installed,
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
  -- disable auto-enable so lspconfig.lua controls server setup (avoids duplicate clients)
  automatic_enable = false,
})

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "prettier", -- ts/js formatter
    "stylua", -- lua formatter
    "eslint_d", -- ts/js linter
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
