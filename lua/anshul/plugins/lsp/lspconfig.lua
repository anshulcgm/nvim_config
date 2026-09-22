-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set('n', 'gr', require('telescope.builtin').lsp_references, nil)
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "ts_ls" then
    keymap.set("n", "<leader>oi", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports.ts" },
          diagnostics = {},
        },
      })
    end, opts) -- organize imports
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

local function command_output(command)
  local output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local result = nil
  for line in output:gmatch("[^\r\n]+") do
    line = vim.fn.trim(line)
    if line ~= "" and not line:match("^bash: warning:") then
      result = line
    end
  end
  return result
end

local clangd_cmd = {
  "clangd",
  "--background-index",
  "--query-driver=/nix/store/*-clang-wrapper-*/bin/clang++,/nix/store/*-clang-wrapper-*/bin/c++",
}

local clang_resource_dir = command_output("clang++ -print-resource-dir")
if clang_resource_dir and clang_resource_dir ~= "" then
  table.insert(clangd_cmd, "--resource-dir=" .. clang_resource_dir)
end

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
vim.lsp.config("html", {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure typescript server
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure css server
vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure tailwindcss server
vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure emmet language server
vim.lsp.config("emmet_ls", {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure clangd server
vim.lsp.config("clangd", {
  cmd = clangd_cmd,
  capabilities = capabilities,
  on_attach = on_attach
})

-- configure pylsp server
vim.lsp.config("pylsp", {
  capabilities = capabilities,
  on_attach = on_attach
})

-- configure lua server (with special settings)
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

vim.lsp.enable({
  "html",
  "ts_ls",
  "cssls",
  "tailwindcss",
  "emmet_ls",
  "clangd",
  "pylsp",
  "lua_ls",
})
