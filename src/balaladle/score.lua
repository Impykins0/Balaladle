BALALADLE.CORE.SCORE = BALALADLE.CORE.SCORE or {}
local daily_deck = BALALADLE.CORE.DECK
local misc_utils = BALALADLE.UTILS.MISC

local function save_old_state(winning_hand, other_cards)
    local cards = G.hand.cards
    local jokers = G.jokers.cards
    local highlighted_hand = G.hand.highlighted
    local highlighted_states = {}

    for _, card in ipairs(winning_hand) do
        highlighted_states[card] = card.highlighted
    end

    for _, card in ipairs(other_cards) do
        highlighted_states[card] = card.highlighted
    end

    return {
        cards = cards,
        jokers = jokers,
        highlighted_hand = highlighted_hand,
        highlighted_states = highlighted_states
    }
end

local function create_simulation_state(winning_hand, other_cards)
    local sim_hand = {}

    for _, card in ipairs(winning_hand) do
        card.highlighted = true
        sim_hand[#sim_hand + 1] = card
    end

    for _, card in ipairs(other_cards) do
        card.highlighted = false
        sim_hand[#sim_hand + 1] = card
    end

    G.hand.cards = misc_utils.shuffle(sim_hand, "hand_shuffle")
    G.jokers.cards = misc_utils.shuffle(G.jokers.cards, "joker_shuffle")
    G.hand.highlighted = winning_hand
end

local function restore_old_state(old_state)
    G.hand.cards = old_state.cards
    G.jokers.cards = old_state.jokers
    G.hand.highlighted = old_state.highlighted_hand

    for card, highlighted in pairs(old_state.highlighted_states) do
        card.highlighted = highlighted
    end
end

local function simulate_cards(winning_hand, other_cards)
    local old_state = save_old_state(winning_hand, other_cards)
    create_simulation_state(winning_hand, other_cards)

    local success, result = pcall(DV.SIM.run)

    restore_old_state(old_state)

    if not success then
        error(result)
    end

    return result.score.exact
end

if not BALALADLE.CORE.SCORE.get_score then
    function BALALADLE.CORE.SCORE.get_score()
        if not BALALADLE.CORE.SCORE.final_score then
            local winning_hand = daily_deck.get_winning_hand()
            local other_cards = 
                misc_utils.slice(daily_deck.get_other_cards(), 1, 5)
            BALALADLE.CORE.SCORE.final_score = 
                simulate_cards(winning_hand, other_cards)
        end

        return BALALADLE.CORE.SCORE.final_score
    end
end