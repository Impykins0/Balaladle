local daily_utils = assert(SMODS.load_file("src/utils/daily.lua"))()

local function random_select(table)
    if #table == 0 then
        return nil
    end

    local index = math.random(1, #table)
    return table[index]
end

local M = {}

function M.get_jokers(amount)
    local pool = {}
    local selected = {}
    local banned_table = {}

    local banned_cards = daily_utils.get_banned_cards()

    for _, card in pairs(banned_cards) do
        banned_table[card.id] = true
    end

    for _, joker in pairs(G.P_CENTER_POOLS.Joker) do
        if joker.mod or not joker.unlocked or banned_table[joker.key] then
            goto continue
        end

        pool[#pool + 1] = joker.key

        ::continue::
    end

    math.randomseed(daily_utils.seed)

    for i = 1, math.min(amount, #pool) do
        selected[#selected + 1] = {
            id = random_select(pool),
            eternal = true,
        }
    end

    return selected
end

return M