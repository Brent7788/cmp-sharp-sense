--=====================================================START OF cshar import

print("cmp-sharp-sense plugin")

-- TODO Here I need to append my Rust program
-- vim.opt.runtimepath:append("~/Documents/projects/nvim-sharp-sense/target/release")

local cmp = require 'cmp'
local sharp_sense = nil;

cmp.event:on("complete_done", function(value)
  print("His this working")

  if sharp_sense == nil then
    return
  end

  local active_entry = value.entry

  if active_entry == nil then
    return
  end

  local completion_item = active_entry.completion_item

  if completion_item and completion_item.is_csharp_snip then
    -- local sharp_sense = require "main_foo"
    local currnetFilePath = vim.api.nvim_buf_get_name(0)

    local bufNumber = vim.api.nvim_get_current_buf();

    local timer = vim.loop.new_timer()

    timer:start(100, 0, vim.schedule_wrap(function()
      vim.api.nvim_buf_set_lines(bufNumber, 0, 0, false, { completion_item.namespace })
      vim.cmd(':w')
    end))

    -- sharp_sense.import(completion_item, currnetFilePath)

    -- local timer = vim.loop.new_timer()

    -- timer:start(300, 0, vim.schedule_wrap(function()
    --   --Refresh page
    --   vim.cmd(':e!')
    --   --Jump on line down
    --   vim.cmd('norm! j')
    --   -- vim.cmd('norm! l')
    --   -- vim.cmd(vim.api.nvim_replace_termcodes('norm! <Esc>', true, true, true))
    --   vim.api.nvim_command('startinsert!')
    --   -- vim.cmd(vim.api.nvim_replace_termcodes('norm! <S-$>', true, true, true))
    --   -- vim.cmd('norm! a')
    -- end))

    print('Should have import, this is new' .. bufNumber)
  end

  -- print(vim.inspect(completion_item));

  -- -- local log = vim.inspect(cmp.get_active_entry())
  -- -- local log = cmp.get_active_entry()

  -- local currnetFilePath = vim.api.nvim_buf_get_name(0)
  -- print(currnetFilePath)

  -- print(vim.inspect(log.completion_item));
  -- -- print(log.completion_item.data.uri)
  -- print(log.completion_item.label)

  --TODO Find a way to convert lua table to json string
  -- local filepath = HOME .. "/Downloads/testlog.txt"
  -- local lines = { log }

  -- vim.api.nvim_call_function("writefile", { lines, filepath })
end)

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

-- source.get_trigger_characters = function()
--   return { '@' }
-- end

-- source.get_keyword_pattern = function()
--   -- Add dot to existing keyword characters (\k).
--   return [[\%(\k\|\.\)\+]]
-- end

function source:complete(request, callback)
  if sharp_sense == nil then
    return
  end

  local input = string.sub(request.context.cursor_before_line, request.offset - 1)

  local currnetFilePath = vim.api.nvim_buf_get_name(0)

  -- local s = require "main_foo";
  local results = sharp_sense.search(input, currnetFilePath);

  -- print(vim.inspect(results))
  -- print("Helloo in", input)
  -- print(input)
  callback(results)
end

vim.api.nvim_create_user_command("TestSave", function()
  vim.cmd(':w');
end, {})

vim.api.nvim_create_user_command("CmpRegisterImportSource", function()
  sharp_sense = require "main_foo";
  local currnetFilePath = vim.api.nvim_buf_get_name(0)
  print(currnetFilePath)

  local mySources = cmp.get_config().sources;

  if #mySources > 1 and mySources[#mySources].name ~= "handles" or mySources == nil or #mySources == 0 then
    print("Adding handles")
    -- table.insert(mySources, { name = 'handles' })

    cmp.register_source('handles', source.new())

    cmp.setup.filetype('cs', {
      -- cmp.setup.filetype('lua', {
      sources = {
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'handles' }, -- GitHub handles; eg. @wincent → Greg Hurrell <wincent@github.com>
      }
    })
  end
end, {})

-- print(vim.inspect(cmp.core.sources[1].context.filetype))
-- print(cmp.core.sources[1].context.filetype)


-- local filepath = HOME .. "/Downloads/testlog.txt"
-- local lines = { vim.inspect(cmp) }

-- vim.api.nvim_call_function("writefile", { lines, filepath })

--=====================================================End OF cshar import
