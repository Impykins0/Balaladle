local function random_select(table)
    if #table == 0 then
        return nil
    end

    local index = math.random(1, #table)
    return table[index]
end

local M = {}



return M