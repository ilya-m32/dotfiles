-- gp.nvim
local conf = {
  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1/chat/completions",
      secret = os.getenv("OPENAI_API_KEY")
    }
  },
  whisper = {
    disable = false,
  },
  default_command_agent = CodeGPT4,
  default_chat_agent = ChatGPT4,
  agents = {
    {
      name = "ChatGPT4",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "o3-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.\n\n"
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
    },
    {
      name = "CodeGPT4",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are an AI working as a code editor.\n\n"
        .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
        .. "START AND END YOUR ANSWER WITH:\n\n```",
    },
  },
  hooks = {
    UnitTests = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
      .. "```{{filetype}}\n{{selection}}\n```\n\n"
      .. "Please respond by writing table driven unit tests for the code above."
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.vnew, agent, template)
    end,
    CodeReview = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
      .. "```{{filetype}}\n{{selection}}\n```\n\n"
      .. "Please analyze for code smells and suggest improvements."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
    end,
    -- example of making :%GpChatNew a dedicated command which
    -- opens new chat with the entire current buffer as a context
    BufferChatNew = function(gp, _)
      -- call GpChatNew command in range mode on whole buffer
      vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
    end,
  }
}

require("gp").setup(conf)
local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end

-- Chat commands
vim.keymap.set({"n", "i"}, "<Leader>Gc", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat"))
vim.keymap.set({"n", "i"}, "<Leader>Gt", "<cmd>GpChatToggle vsplit<cr>", keymapOptions("Toggle Chat"))

vim.keymap.set({"n", "i"}, "<Leader>Ga", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<Leader>Gx", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))


vim.keymap.set({"n", "v"}, "<Leader>Gi", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))
vim.keymap.set({"n", "v"}, "<Leader>Gr", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual rewrite"))
vim.keymap.set({"n", "v"}, "<Leader>Gc", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual rewrite"))
vim.keymap.set({"n", "v"}, "<Leader>Gx", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual GpContext"))
