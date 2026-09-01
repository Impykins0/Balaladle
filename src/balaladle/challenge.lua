local daily_jokers = BALALADLE.CORE.JOKERS
local daily_deck = BALALADLE.CORE.DECK

local starter_jokers = daily_jokers.get_jokers(5)
local starter_deck = daily_deck.starter_deck(8)
local banned_jokers = daily_jokers.get_banned_jokers()

SMODS.Challenge {
    key = 'daily_1',

    rules = {
        custom = {
            { id = "impy_single_blind" },
            { id = "impy_close_to_target" },
            { id = "impy_single_ante", no_ui = true },
            { id = "impy_calculated_score", no_ui = true },
            { id = "impy_leaderboard", no_ui = true },
        },
        modifiers = {
            { id = "hands", value = 1 },
            { id = "discards", value = 0 },
        },
    },

    jokers = starter_jokers,

    deck = {
        type = "Challenge Deck",
        cards = starter_deck,
    },

    restrictions = {
        banned_cards = banned_jokers,
    },

    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                -- daily_deck.set_editions_and_seals()
                G.GAME.round_resets.blind_choices.Boss = "bl_impy_blank"

                return true
            end
        }))
    end
}