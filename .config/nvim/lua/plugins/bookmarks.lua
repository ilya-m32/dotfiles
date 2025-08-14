--[[
  Shameless copypaste from
  https://github.com/olimorris/dotfiles/blob/main/.config/nvim/lua/util/marks.lua
--]]

-- Convert a mark number (1-9) to its corresponding character (A-I)
local function mark2char(mark)
  if mark:match("[1-9]") then
    return string.char(mark + 64)
  end
  return mark
end

local function list_marks()
  require('fzf-lua').marks()
end

local vim = vim

-- Add Marks ------------------------------------------------------------------
vim.keymap.set("n", "m", function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  vim.cmd("mark " .. char)
  if mark:match("[1-9]") then
    vim.notify("Added mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
  else
    vim.fn.feedkeys("m" .. mark, "n")
  end
end, { desc = "Add mark" })

-- Go To Marks ----------------------------------------------------------------
vim.keymap.set("n", "'", function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  local mark_pos = vim.api.nvim_get_mark(char, {})
  if mark_pos[1] == 0 then
    return vim.notify("No mark at " .. mark, vim.log.levels.WARN, { title = "Marks" })
  end

  vim.fn.feedkeys("'" .. mark2char(mark), "n")
end, { desc = "Go to mark" })

-- List Marks -----------------------------------------------------------------
vim.keymap.set("n", "<Leader>mm", function()
  list_marks()
end, { desc = "List marks" })

-- Delete Marks ---------------------------------------------------------------
vim.keymap.set("n", "<Leader>md", function()
  local mark = vim.fn.getcharstr()
  vim.api.nvim_del_mark(mark2char(mark))
  vim.notify("Deleted mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete mark" })

vim.keymap.set("n", "<Leader>mD", function()
  vim.cmd("delmarks A-I")
  vim.notify("Deleted all marks", vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete all marks" })
