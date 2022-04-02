local M = {}

function M.current_mode_not_normal()
    return vim.fn.mode() ~= 'n'
end

return M

-- vim: shiftwidth=4
