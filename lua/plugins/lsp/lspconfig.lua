return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- NOTE: LSP Keybinds

		-- NOTE : Moved all this to Mason including local variables
		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()
		-- Change the Diagnostic symbols in the sign column (gutter)

		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		-- Set the diagnostic config with all icons
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		-- NOTE :
		-- Moved back from mason_lspconfig.setup_handlers from mason.lua file
		-- as mason setup_handlers is deprecated & its causing issues with lsp settings
		--
		-- Setup servers
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		lspconfig.marksman.setup({
			capabilities = capabilities,
			filetypes = { "markdown" },
		})

		-- Config lsp servers here
		-- lua_ls
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
		-- emmet_ls
		-- lspconfig.emmet_ls.setup({
		--     capabilities = capabilities,
		--     filetypes = {
		--         "html",
		--         "typescriptreact",
		--         "javascriptreact",
		--         "css",
		--         "sass",
		--         "scss",
		--         "less",
		--         "svelte",
		--     },
		-- })
		--
		-- emmet_language_server
		lspconfig.emmet_language_server.setup({
			capabilities = capabilities,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- ts_ls (replaces tsserver)
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			root_dir = function(fname)
				local util = lspconfig.util
				return not util.root_pattern("deno.json", "deno.jsonc")(fname)
					and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
			end,
			single_file_support = false,
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
		})

		-- HACK: If using Blink.cmp Configure all LSPs here

		-- ( comment the ones in mason )
		-- local lspconfig = require("lspconfig")
		-- local capabilities = require("blink.cmp").get_lsp_capabilities() -- Import capabilities from blink.cmp

		-- Configure lua_ls
		-- lspconfig.lua_ls.setup({
		--     capabilities = capabilities,
		--     settings = {
		--         Lua = {
		--             diagnostics = {
		--                 globals = { "vim" },
		--             },
		--             completion = {
		--                 callSnippet = "Replace",
		--             },
		--             workspace = {
		--                 library = {
		--                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
		--                     [vim.fn.stdpath("config") .. "/lua"] = true,
		--                 },
		--             },
		--         },
		--     },
		-- })
		--
		-- -- Configure tsserver (TypeScript and JavaScript)
		-- lspconfig.ts_ls.setup({
		--     capabilities = capabilities,
		--     root_dir = function(fname)
		--         local util = lspconfig.util
		--         return not util.root_pattern('deno.json', 'deno.jsonc')(fname)
		--             and util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git')(fname)
		--     end,
		--     single_file_support = false,
		--     on_attach = function(client, bufnr)
		--         -- Disable formatting if you're using a separate formatter like Prettier
		--         client.server_capabilities.documentFormattingProvider = false
		--     end,
		--     init_options = {
		--         preferences = {
		--             includeCompletionsWithSnippetText = true,
		--             includeCompletionsForImportStatements = true,
		--         },
		--     },
		-- })

		-- Add other LSP servers as needed, e.g., gopls, eslint, html, etc.
		-- lspconfig.gopls.setup({ capabilities = capabilities })
		-- lspconfig.html.setup({ capabilities = capabilities })
		-- lspconfig.cssls.setup({ capabilities = capabilities })
	end,
}
