local daily_utils = assert(SMODS.load_file("src/utils/daily.lua"))()
local daily_jokers = assert(SMODS.load_file("src/balaladle/jokers.lua"))()

SMODS.Challenge {
    key = 'daily_1',

    rules = {
        custom = {
            { id = "impy_single_blind" },
            { id = "impy_exact_score" },
        },
        modifiers = {
            { id = "hands", value = 1 },
            { id = "discards", value = 0 },
        },
    },

    jokers = daily_jokers.get_jokers(5),

    restrictions = {
        banned_cards = daily_utils.get_banned_cards(),
    }
}