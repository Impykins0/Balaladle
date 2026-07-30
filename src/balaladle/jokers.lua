local daily_utils = assert(SMODS.load_file("src/utils/daily.lua"))()
local misc_utils = assert(SMODS.load_file("src/utils/misc.lua"))()

local M = {}

function M.get_jokers(amount)
    local pool = {}
    local selected = {}
    local banned_table = {}

    local banned_jokers = daily_utils.get_banned_jokers()

    for _, card in pairs(banned_jokers) do
        banned_table[card.id] = true
    end

    for _, joker in pairs(G.P_CENTER_POOLS.Joker) do
        if joker.mod or not joker.unlocked or banned_table[joker.key] then
            goto continue
        end

        pool[#pool + 1] = joker.key

        ::continue::
    end

    math.randomseed(daily_utils.get_seed())

    for i = 1, math.min(amount, #pool) do
        selected[#selected + 1] = {
            id = misc_utils.random_select(pool),
            eternal = true,
        }
    end

    return selected
end

return M