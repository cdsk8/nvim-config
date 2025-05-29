--General mappings

vim.keymap.set({ "n", "v" }, "<leader>w", vim.cmd.write, { desc = "Write file" })
vim.keymap.set({ "n", "v" }, "<leader>q", vim.cmd.quit, { desc = "Quit editor" })

local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })
-- In a seach, it keeps the focus in the center of the view
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Move selected lines a tab forward or backwards
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- the how it be paste
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste NoChange Clipboard" })

-- remember yanked
vim.keymap.set("v", "p", '"_dp', { desc = "Paste remembering", noremap = true, silent = true })

-- Copies or Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system", noremap = true, silent = true })

-- leader d delete wont remember as yanked/clipboard when delete pasting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copy" })

-- ctrl c as escape cuz Im lazy to reach up to the esc key
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

-- prevent x delete from registering when next paste
vim.keymap.set("n", "x", '"_x', opts)

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

----------Here i create the groups for Which-key and future commands
local wk = require("which-key")

wk.add({
    { "<leader>b", group = "Buffers", icon = "" },
    { "<leader>c", group = "Code Formatting", icon = "󰅨" },
    { "<leader>s", group = "Search" },
    { "<leader>x", group = "File Management", icon = "" },
    { "<leader>l", group = "Lsp", icon = "" },
    { "<leader>st", group = "TodoComments", icon = "" },
    { "<leader>lw", group = "Workspace Folders", icon = "" },
    { "<leader>t", group = "Trouble" },
    { "<leader>n", group = "Notes", icon = "" },
})
---------------------------------------------------------------------------------------------------------
---BUFFERS------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>bd", "<CMD>bd<CR>", { desc = "Buffer delete" })
vim.keymap.set("n", "<leader>bD", "<CMD>bd!<CR>", { desc = "Buffer delete without save" })
vim.keymap.set("n", "<leader>ba", "<CMD>CloseUnpinnedBuffers<CR>", { desc = "Close all Unpinned buffers" })
vim.keymap.set("n", "<leader>bp", "<CMD>TogglePinBuffer<CR>", { desc = "Toggle Pin in a buffer" })
vim.keymap.set("n", "<leader>bl", "<CMD>ListPinnedBuffers<CR>", { desc = "List pinned buffers" })

--Code Formatting--------------------------------------------------------------------------------------------------------

-- format without prettier using the built in
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format" })
-- Search and replace Multifile with Grug_far
vim.keymap.set({ "n", "v" }, "<leader>cr", function()
    local grug = require("grug-far")
    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    grug.open({
        transient = true,
        prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
    })
end, { desc = "Search and Replace" })

--Search-------------------------------------------------------------------------------------------------------

-- Telescope

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
vim.keymap.set("n", "<leader>sr", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Telescope Commands" })
--Telescope look for recently opened files
vim.keymap.set("n", "<leader>so", function()
    vim.cmd.Telescope("oldfiles")
end, { desc = "Search recent files" })
--Telescope live grep for selected string or next word on cursor
vim.keymap.set("n", "<leader>ss", function()
    local word = vim.fn.expand("<cWORD>")
    builtin.grep_string({ search = word })
end, { desc = "Search for selected string" })

vim.keymap.set("v", "<leader>ss", function()
    -- Yank selected text into register s
    vim.cmd('normal! "sy') -- executes before visual mode exits
    local selected = vim.fn.getreg("s")
    -- Trim leading and trailing whitespace and newlines
    selected = selected:gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n", " ")
    require("telescope.builtin").grep_string({ search = selected })
end, { desc = "Search for selected text", silent = true })

vim.keymap.set("n", "<C-i>", vim.cmd.bnext, { desc = "Next Buffer", silent = true })
vim.keymap.set("n", "<C-o>", vim.cmd.bprev, { desc = "Prev Buffer", silent = true })
--------TodoComments-------------------------------------------------------------------------------------------------------

-- TODO comments search, quick
vim.keymap.set("n", "<leader>stt", function()
    vim.cmd.TodoTelescope("keywords=TODO,FIX")
end, { desc = "TODO,FIX comment" })
-- TODO comments full search
vim.keymap.set("n", "<leader>sta", function()
    vim.cmd.TodoTelescope()
end, { desc = "All comments" })

--File Management-------------------------------------------------------------------------------------------------------

-- Write all buffers and quit
vim.keymap.set({ "n", "v" }, "<leader>xQ", vim.cmd.wqa, { desc = "Write and Quit all" })
-- Executes shell command from in here making file executable
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })
-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>xp", function()
    local filePath = vim.fn.expand("%:~")                -- Gets the file path relative to the home directory
    vim.fn.setreg("+", filePath)                         -- Copy the file path to the clipboard register
    print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })

--Lsp-------------------------------------------------------------------------------------------------------

-- -- Toggle LSP diagnostics visibility
-- local isLspDiagnosticsVisible = true
-- vim.keymap.set("n", "<leader>lx", function()
--     isLspDiagnosticsVisible = not isLspDiagnosticsVisible
--     vim.diagnostic.config({
--         virtual_text = isLspDiagnosticsVisible,
--         underline = isLspDiagnosticsVisible
--     })
-- end, { desc = "Toggle LSP diagnostics" })
-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--     callback = function(ev)
--         -- Enable completion triggered by <c-x><c-o>
--         vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
--         -- Buffer local mappings.
--         -- See `:help vim.lsp.*` for documentation on any of the below functions
--         vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Lsp Declaration" })
--         vim.keymap.set('n', '<leader>lK', vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show help page" })
--         vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "IDK" })
--         vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder,
--             { buffer = ev.buf, desc = "Add workspace folder" })
--         vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder,
--             { buffer = ev.buf, desc = "Delete workspace folder" })
--         vim.keymap.set('n', '<space>lwl', function()
--             print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--         end, { buffer = ev.buf, desc = "List workspace folders" })
--         vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol (Document)" })
--         vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {buffer = ev.buf, desc="Diagnostics for line"
--         local ok, telescope = pcall(require, 'telescope.builtin')
--         if ok then
--             vim.keymap.set('n', '<leader>ld', telescope.lsp_definitions, { desc = "Lsp definitions (Telescope)" })
--             vim.keymap.set('n', '<leader>li', telescope.lsp_implementations, { desc = "Lsp implementations (Telescope)" })
--             vim.keymap.set('n', '<space>lt', telescope.lsp_type_definitions,
--                 { desc = "Lsp Type definitions (Telescope)" })
--             vim.keymap.set('n', '<leader>lr', telescope.lsp_references, { desc = "Lsp references (Telescope)" })
--             vim.keymap.set('n', '<leader>ls', telescope.lsp_document_symbols,
--                 { desc = " Lsp Document symbols (Telescope)" })
--             vim.keymap.set('n', '<leader>cD', telescope.diagnostics, { desc = "Diagnostics on Workspace" })
--             vim.keymap.set('n', '<leader>cd', function()
--                 telescope.diagnostics({ bufnr = 0 })
--             end, { desc = "Diagnostics on Buffer" })
--         else
--             vim.notify("Telescope not loaded: skipping <leader>l keymap", vim.log.levels.WARN)
--         end
--     end,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
--     group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--     callback = function(ev)
--         -- Buffer local mappings
--         -- Check `:help vim.lsp.*` for documentation on any of the below functions
--         local opts = { buffer = ev.buf, silent = true }
--
--         -- keymaps
--         opts.desc = "Show LSP references"
--         vim.keymap.set("n", "lr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
--
--         opts.desc = "Go to declaration"
--         vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts) -- go to declaration
--
--         opts.desc = "Show LSP definitions"
--         vim.keymap.set("n", "ld", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
--
--         opts.desc = "Show LSP implementations"
--         vim.keymap.set("n", "li", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
--
--         opts.desc = "Show LSP type definitions"
--         vim.keymap.set("n", "lt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
--
--         opts.desc = "See available code actions"
--         vim.keymap.set({ "n", "v" }, "<leader>la", function() vim.lsp.buf.code_action() end, opts) -- see available code actions, in visual mode will apply to selection
--
--         opts.desc = "Smart rename"
--         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
--
--         opts.desc = "Show buffer diagnostics"
--         vim.keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
--
--         opts.desc = "Show line diagnostics"
--         vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts) -- show diagnostics for line
--
--         opts.desc = "Show documentation for what is under cursor"
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
--
--         opts.desc = "Restart LSP"
--         vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
--
--         vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--     end,
-- })
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Lsp Declaration" })
        vim.keymap.set("n", "<leader>lK", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show help page" })
        vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "IDK" })
        vim.keymap.set(
            "n",
            "<space>lwa",
            vim.lsp.buf.add_workspace_folder,
            { buffer = ev.buf, desc = "Add workspace folder" }
        )
        vim.keymap.set(
            "n",
            "<space>lwr",
            vim.lsp.buf.remove_workspace_folder,
            { buffer = ev.buf, desc = "Delete workspace folder" }
        )
        vim.keymap.set("n", "<space>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = ev.buf, desc = "List workspace folders" })
        vim.keymap.set("n", "<space>ln", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol (Document)" })
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Diagnostics for line" })
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
            vim.keymap.set("n", "<leader>ld", telescope.lsp_definitions, { desc = "Lsp definitions (Telescope)" })
            vim.keymap.set(
                "n",
                "<leader>li",
                telescope.lsp_implementations,
                { desc = "Lsp implementations (Telescope)" }
            )
            vim.keymap.set(
                "n",
                "<space>lt",
                telescope.lsp_type_definitions,
                { desc = "Lsp Type definitions (Telescope)" }
            )
            vim.keymap.set("n", "<leader>lr", telescope.lsp_references, { desc = "Lsp references (Telescope)" })
            vim.keymap.set(
                "n",
                "<leader>ls",
                telescope.lsp_document_symbols,
                { desc = " Lsp Document symbols (Telescope)" }
            )
            vim.keymap.set("n", "<leader>cD", telescope.diagnostics, { desc = "Diagnostics on Workspace" })
            vim.keymap.set("n", "<leader>cd", function()
                telescope.diagnostics({ bufnr = 0 })
            end, { desc = "Diagnostics on Buffer" })
        else
            vim.notify("Telescope not loaded: skipping <leader>l keymap", vim.log.levels.WARN)
        end
    end,
})
vim.g.nvim_cmp_enabled = true
vim.g.nvim_cmp_docs_enabled = true

vim.api.nvim_create_user_command("ToggleAutocomplete", function()
    vim.g.nvim_cmp_enabled = not vim.g.nvim_cmp_enabled
    require("cmp").setup({ enabled = vim.g.nvim_cmp_enabled })
    vim.notify("nvim-cmp " .. (vim.g.nvim_cmp_enabled and "enabled" or "disabled"))
end, {})

vim.api.nvim_create_user_command("ToggleDOCS", function()
    if vim.g.nvim_cmp_docs_enabled then
        require("cmp").setup({
            window = { documentation = require("cmp").config.disable },
        })
    else
        require("cmp").setup({
            window = {
                documentation = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    max_width = 80,
                    max_height = 20,
                    winhighlight = "Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
                    zindex = 1001,
                },
            },
        })
    end
    vim.g.nvim_cmp_docs_enabled = not vim.g.nvim_cmp_docs_enabled
    vim.notify("nvim-cmp-docs " .. (vim.g.nvim_cmp_docs_enabled and "enabled" or "disabled"))
end, {})

vim.keymap.set("n", "<leader>ct", "<CMD>ToggleAutocomplete<CR>", { desc = "ToggleAutocomplete" })
vim.keymap.set("n", "<leader>cp", "<CMD>ToggleDOCS<CR>", { desc = "ToggleDOCS" })
vim.keymap.set("n", "<leader>cs", "<CND>ToggleNoiceSignature<CR>", { desc = "Toggle Noice Signature Help" })

vim.keymap.set("n", "<leader>nd", "<CMD>DocsSplit<CR>", { desc = "Docs Split window" })
vim.keymap.set("n", "<leader>nD", "<CMD>Docs<CR>", { desc = "Docs" })
vim.keymap.set("n", "<leader>nn", "<CMD>NotesSplit<CR>", { desc = "Notes Split window" })
vim.keymap.set("n", "<leader>nN", "<CMD>Notes<CR>", { desc = "Notes" })
