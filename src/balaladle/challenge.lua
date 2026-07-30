local daily_utils = assert(SMODS.load_file("src/utils/daily.lua"))()
local daily_jokers = assert(SMODS.load_file("src/balaladle/jokers.lua"))()
local daily_deck = assert(SMODS.load_file("src/balaladle/deck.lua"))()

SMODS.Challenge {
    key = 'daily_1',

    rules = {
        custom = {
            { id = "impy_single_blind" },
            { id = "impy_exact_score" },
            { id = "impy_single_ante", no_ui = true },
        },
        modifiers = {
            { id = "hands", value = 1 },
            { id = "discards", value = 0 },
        },
    },

    jokers = daily_jokers.get_jokers(5),

    deck = {
        type = "Challenge Deck",
        cards = daily_deck.starter_deck(8),
    },

    restrictions = {
        banned_cards = daily_utils.get_banned_jokers(),
    },

    -- TODO: find out how to set editions and seals in the starter deck so it
    -- displays correctly in the preview (card.lua is promising)
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                daily_deck.set_deck()
                return true
            end
        }))
    end
}