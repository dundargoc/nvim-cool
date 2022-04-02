local M = {}

function M.current_mode_not_normal()
    return vim.fn.mode() ~= 'n'
end

function M.set_mapping()
    vim.keymap.set('', '<Plug>(StopHL)', ':<C-U>nohlsearch<cr>', { silent = true })
end

return M

-- vim: shiftwidth=4
