function apply_to_visual_lines(fn, start_line, end_line)
	for lnum = start_line, end_line do
		local line = vim.fn.getline(lnum)
		local new_line = fn(line)
		if new_line ~= nil then
			vim.fn.setline(lnum, new_line)
		end
	end
end

vim.api.nvim_create_user_command("Docs", function()
	local notes_dir = vim.fn.getcwd() .. "/docs"
	local notes_file = notes_dir .. "/index.md"

	-- Create the notes directory if it doesn't exist
	if vim.fn.isdirectory(notes_dir) == 0 then
		vim.fn.mkdir(notes_dir, "p")
	end

	-- Open the index.md file
	vim.cmd("e " .. notes_file)
end, {})

vim.api.nvim_create_user_command("DocsSplit", function()
	local notes_dir = vim.fn.getcwd() .. "/docs"
	local notes_file = notes_dir .. "/index.md"

	-- Create the notes directory if it doesn't exist
	if vim.fn.isdirectory(notes_dir) == 0 then
		vim.fn.mkdir(notes_dir, "p")
	end

	-- Open the index.md file
	vim.cmd("vsplit " .. notes_file)
end, {})

vim.api.nvim_create_user_command("NotesSplit", function()
	vim.cmd("vsplit /notes/index.md")
end, {})

vim.api.nvim_create_user_command("Notes", function()
	vim.cmd("e /notes/index.md")
end, {})

_G.pinned_buffers = _G.pinned_buffers or {}

vim.api.nvim_create_user_command("PinBuffer", function()
	local bufnr = vim.api.nvim_get_current_buf()
	_G.pinned_buffers[bufnr] = true
	print("Pinned buffer " .. bufnr)
end, {})

vim.api.nvim_create_user_command("UnpinBuffer", function()
	local bufnr = vim.api.nvim_get_current_buf()
	_G.pinned_buffers[bufnr] = nil
	print("Unpinned buffer " .. bufnr)
end, {})

vim.api.nvim_create_user_command("TogglePinBuffer", function()
	local bufnr = vim.api.nvim_get_current_buf()
	if _G.pinned_buffers[bufnr] then
		_G.pinned_buffers[bufnr] = nil
		print("Unpinned buffer " .. bufnr)
	else
		_G.pinned_buffers[bufnr] = true
		print("Pinned buffer " .. bufnr)
	end
end, {})

vim.api.nvim_create_user_command("ListPinnedBuffers", function()
	local pinned = _G.pinned_buffers or {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted and pinned[bufnr] then
			vim.print(bufnr)
		end
	end
end, {})

vim.api.nvim_create_user_command("CloseUnpinnedBuffers", function()
	local pinned = _G.pinned_buffers or {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted and not pinned[bufnr] then
			vim.cmd("bd " .. bufnr)
		end
	end
end, {})

local function InsertTodoTag(tag)
	local cs = vim.bo.commentstring or "// %s"
	if not cs:match("%%s") then
		cs = "// %s"
	end
	local line = cs:format(tag .. ": ")
	vim.api.nvim_put({ line }, "l", true, true)
end

-- Define a user command :InsertTodo <tag>
vim.api.nvim_create_user_command("InsertTodoTag", function(opts)
	local tag = opts.args or "TODO"
	InsertTodoTag(tag)
end, {
	nargs = "?", -- optional argument
	complete = function(_, _)
		return { "TODO", "FIXME", "HACK", "NOTE", "BUG", "WARN" }
	end,
	desc = "Insert a comment line with a tag (e.g. TODO, FIXME)",
})

local function set_checkbox_state(state)
	local line = vim.api.nvim_get_current_line()
	local new_line = line:gsub("^(%s*)%- %[[ xX~%-]%]", "%1- " .. state, 1)
	vim.api.nvim_set_current_line(new_line)
end

vim.api.nvim_create_user_command("CheckboxState", function(opts)
	local tag = opts.args or "[ ]"
	set_checkbox_state(tag)
end, {
	nargs = "?",
	complete = function(_, _)
		return { "[x]", "[-]", "[~]", "[ ]" }
	end,
	desc = "Change checkbox state",
})

function set_checkbox_state_line(state)
	return function(line)
		return line:gsub("^(%s*)%- %[[ xX~%-]%]", "%1- " .. state, 1)
	end
end
vim.api.nvim_create_user_command("CheckboxVisual", function(opts)
	local tag = opts.args or "[ ]"
	local fn = set_checkbox_state_line(tag)

	print("line1:", opts.line1)
	print("line2:", opts.line2)

	apply_to_visual_lines(fn, opts.line1, opts.line2)
end, {
	nargs = "?",
	range = true,
	desc = "Set checkbox state in visual selection",
	complete = function()
		return { "[x]", "[-]", "[~]", "[ ]" }
	end,
})
