BALALADLE.CORE.SCORE = BALALADLE.CORE.SCORE or {}
local daily_deck = BALALADLE.CORE.DECK
local misc_utils = BALALADLE.UTILS.MISC

local HAND_SIZE = 8

local function save_card_state(card)
    return {
        base = DV.SIM.deep_copy(card.base),
        ability = DV.SIM.deep_copy(card.ability),
        center = card.config.center,
        edition = DV.SIM.deep_copy(card.edition),
        seal = card.seal,
        highlighted = card.highlighted,
    }
end

local function restore_card_state(card, state)
    SMODS.change_base(card, state.base.suit, state.base.value)

    card:set_ability(state.center, nil, true)
    card:set_edition(state.edition, true, true)
    card:set_seal(state.seal, true, true)

    card.ability = state.ability
    card.highlighted = state.highlighted
end

local function save_old_state(winning_hand, other_cards)
    local cards = G.hand.cards
    local jokers = G.jokers.cards
    local consumables = G.consumeables.cards
    local highlighted_hand = G.hand.highlighted

    local card_states = {}

    for _, card in ipairs(winning_hand) do
        card_states[card] = save_card_state(card)
    end

    for _, card in ipairs(other_cards) do
        card_states[card] = save_card_state(card)
    end

    return {
        cards = cards,
        jokers = jokers,
        consumables = consumables,
        highlighted_hand = highlighted_hand,
        card_states = card_states,
        hand_levels = DV.SIM.deep_copy(G.GAME.hands),
        dollars = G.GAME.dollars,
    }
end

local function restore_old_state(old_state)
    G.hand.cards = old_state.cards
    G.jokers.cards = old_state.jokers
    G.consumeables.cards = old_state.consumables
    G.hand.highlighted = old_state.highlighted_hand
    G.GAME.dollars = old_state.dollars

    for card, state in pairs(old_state.card_states) do
        restore_card_state(card, state)
    end

    DV.SIM.deep_update(G.GAME.hands, old_state.hand_levels)
end

local function create_simulation_state(winning_hand, other_cards)
    local sim_hand = {}

    for _, card in ipairs(winning_hand) do
        card.highlighted = true
        sim_hand[#sim_hand + 1] = card
    end

    for i, card in ipairs(other_cards) do
        card.highlighted = false
        sim_hand[#sim_hand + 1] = card
    end

    G.hand.cards = misc_utils.shuffle(sim_hand, "hand_shuffle")
    G.jokers.cards = misc_utils.shuffle(G.jokers.cards, "joker_shuffle")

    local state = BALALADLE.CORE.CONSUMABLES.sim_consumables(
        winning_hand, other_cards
    )

    local new_winning_hand = state and state.winning_hand or winning_hand
    G.hand.highlighted = new_winning_hand

    return state
end

local function destroy_temp_cards(temp_cards)
    for _, card in ipairs(temp_cards) do
        if card.remove then
            card:remove()
        end
    end
end

local function simulate_cards(winning_hand, other_cards)
    local old_state = save_old_state(winning_hand, other_cards)
    local sim_state = create_simulation_state(winning_hand, other_cards)

    local success, result = pcall(DV.SIM.run)

    restore_old_state(old_state)
    destroy_temp_cards(sim_state.temp_cards)

    if not success then
        error(result)
    end

    return result.score.exact
end

if not BALALADLE.CORE.SCORE.get_calculated_score then
    function BALALADLE.CORE.SCORE.get_calculated_score()
        if not BALALADLE.CORE.SCORE.calculated_score then
            local winning_hand = daily_deck.get_winning_hand()
            local other_cards =
                misc_utils.slice(daily_deck.get_other_cards(), 1, 5)
            BALALADLE.CORE.SCORE.calculated_score = 
                simulate_cards(winning_hand, other_cards)
        end

        return BALALADLE.CORE.SCORE.calculated_score
    end

    function BALALADLE.CORE.SCORE.set_player_score(target, actual)
        BALALADLE.CORE.SCORE.player_score =
            (math.abs(actual - target) / target) * 100
    end
end