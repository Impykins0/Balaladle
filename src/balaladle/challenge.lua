local daily_jokers = BALALADLE.CORE.JOKERS
local daily_deck = BALALADLE.CORE.DECK
local daily_consumables = BALALADLE.CORE.CONSUMABLES
local misc_utils = BALALADLE.UTILS.MISC

local starter_jokers = daily_jokers.get_jokers(5)
local starter_deck = daily_deck.starter_deck(8)
local starter_consumables = daily_consumables.get_consumables()

local banned_jokers = daily_jokers.get_banned_jokers()
local banned_consumables = daily_consumables.get_banned_consumables()

SMODS.Challenge {
    key = 'daily_1',

    rules = {
        custom = {
            { id = "impy_single_blind" },
            { id = "impy_close_to_target" },
            { id = "impy_friends_leaderboard" },
            { id = "impy_single_ante", no_ui = true },
            { id = "impy_calculated_score", no_ui = true },
            { id = "impy_leaderboard", no_ui = true },
            { id = "impy_share_score", no_ui = true },
        },
        modifiers = {
            { id = "hands", value = 1 },
            { id = "discards", value = 0 },
            { id = "consumable_slots", value = 3},
        },
    },

    jokers = starter_jokers,

    consumeables = starter_consumables,

    deck = {
        type = "Challenge Deck",
        cards = starter_deck,
    },

    restrictions = {
        banned_cards = misc_utils.merge(banned_jokers, banned_consumables),
    },

    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.blind_choices.Boss = "bl_impy_blank"
                BALALADLE.UI.set_leaderboard(
                    BALALADLE.UI.create_UIBox_balaladle_leaderboard()
                )
                return true
            end
        }))
    end
}