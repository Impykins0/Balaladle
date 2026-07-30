local daily_utils = assert(SMODS.load_file("src/utils/daily.lua"))()
local misc_utils = assert(SMODS.load_file("src/utils/misc.lua"))()

local suits = {
    "C", 
    "D", 
    "H", 
    "S"
}

local ranks = {
    "A", 
    "K", 
    "Q", 
    "J", 
    "T",
    "9", 
    "8", 
    "7", 
    "6", 
    "5", 
    "4", 
    "3", 
    "2"
}

local enhancements = {
    "m_stone",
    "m_steel",
    "m_glass",
    "m_gold",
    "m_bonus",
    "m_mult",
    "m_wild",
    nil,
}

local editions = {
    "e_foil",
    "e_holo",
    "e_polychrome",
    false,
}

local seals = {
    "Red",
    "Gold",
    false,
}

local M = {}

function M.starter_deck(size)
    local cards = {}

    math.randomseed(daily_utils.get_seed())

    local i = 1

    while i <= size do
        local rand_suit = misc_utils.random_select(suits)
        local rand_rank = misc_utils.random_select(ranks)
        local rand_en = misc_utils.random_select(enhancements)
        -- local rand_ed = misc_utils.random_select(editions)
        -- local rand_seal = misc_utils.random_select(seals)

        cards[#cards + 1] = {
            s = rand_suit,
            r = rand_rank,
            e = rand_en,
            -- want to set edition and seal
        }

        i = i + 1
    end

    return cards
end

function M.set_deck()
    math.randomseed(daily_utils.get_seed())

    for i = #G.playing_cards, 1, -1 do
        local rand_ed = misc_utils.random_select(editions)
        local rand_seal = misc_utils.random_select(seals)

        if rand_ed then
            G.playing_cards[i]:set_edition(rand_ed, true, true)
        end
        if rand_seal then
            G.playing_cards[i]:set_seal(rand_seal, true, true)
        end
    end
end

return M