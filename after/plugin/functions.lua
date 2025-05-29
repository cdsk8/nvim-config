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
  vim.cmd("vsplit ~/notes/index.md")
end, {})

vim.api.nvim_create_user_command("Notes", function()
  vim.cmd("e ~/notes/index.md")
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
    if vim.api.nvim_buf_is_loaded(bufnr)
        and vim.api.nvim_buf_get_option(bufnr, "buflisted")
        and pinned[bufnr] then
      vim.print(bufnr)
    end
  end
end, {})

vim.api.nvim_create_user_command("CloseUnpinnedBuffers", function()
  local pinned = _G.pinned_buffers or {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr)
        and vim.api.nvim_buf_get_option(bufnr, "buflisted")
        and not pinned[bufnr] then
      vim.cmd("bd " .. bufnr)
    end
  end
end, {})

