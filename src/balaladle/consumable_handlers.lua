local misc_utils = BALALADLE.UTILS.MISC

local CONSUMABLE_HANDLERS = {
    c_empress = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 2, "empress"
        )

        for _, card in ipairs(cards) do
            card:set_ability(G.P_CENTERS["m_mult"], nil, true)
        end
    end,

    c_heirophant = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 2, "heirophant"
        )

        for _, card in ipairs(cards) do
            card:set_ability(G.P_CENTERS["m_bonus"], nil, true)
        end
    end,

    c_chariot = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "chariot"
        )

        if cards[1] then
            cards[1]:set_ability(G.P_CENTERS["m_steel"], nil, true)
        end
    end,

    c_justice = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "justice"
        )

        if cards[1] then
            cards[1]:set_ability(G.P_CENTERS["m_glass"], nil, true)
        end
    end,

    c_strength = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 2, "strength"
        )

        for _, card in ipairs(cards) do
            SMODS.modify_rank(card, 1)
        end
    end,

    c_death = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 2, "death"
        )

        if cards[1] and cards[2] then
            SMODS.change_base(cards[2], cards[1].base.suit, cards[1].base.value)
            cards[2].ability = DV.SIM.deep_copy(cards[1].ability)
            cards[2].edition = DV.SIM.deep_copy(cards[1].edition)
            cards[2].seal = cards[1].seal
        end
    end,

    c_temperance = function(state)
        local total = 0
        for _, joker in ipairs(G.jokers.cards) do
            total = total + (joker.sell_cost or 0)
        end

        G.GAME.dollars = G.GAME.dollars + math.min(total, 50)
    end,

    c_devil = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "devil"
        )

        if cards[1] then
            cards[1]:set_ability(G.P_CENTERS["m_gold"], nil, true)
        end
    end,

    c_star = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 3, "star"
        )

        for _, card in ipairs(cards) do
            SMODS.change_base(card, "Diamonds")
        end
    end,

    c_moon = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 3, "moon"
        )

        for _, card in ipairs(cards) do
            SMODS.change_base(card, "Clubs")
        end
    end,

    c_sun = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 3, "sun"
        )

        for _, card in ipairs(cards) do
            SMODS.change_base(card, "Hearts")
        end
    end,

    c_world = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 3, "world"
        )

        for _, card in ipairs(cards) do
            SMODS.change_base(card, "Spades")
        end
    end,

    c_talisman = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "talisman"
        )

        if cards[1] then
            cards[1]:set_seal("Gold", nil, true)
        end
    end,

    c_deja_vu = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "deja_vu"
        )

        if cards[1] then
            cards[1]:set_seal("Red", nil, true)
        end
    end,

    c_cryptid = function(state)
        local cards = misc_utils.random_select_multi(
            state.all_cards, 1, "cryptid"
        )

        if cards[1] then
            for _ = 1, 2 do
                local copy = copy_card(cards[1])

                G.hand.cards[#G.hand.cards + 1] = copy
                state.all_cards[#state.all_cards + 1] = copy
                state.temp_cards[#state.temp_cards + 1] = copy

                if #state.winning_hand <= 3
                   and misc_utils.contains(state.winning_hand, copy) then
                    state.winning_hand[#state.winning_hand + 1] = copy
                    copy.highlighted = true
                else
                    state.other_cards[#state.other_cards + 1] = copy
                    copy.highlighted = false
                end
            end
        end
    end,
}

local function level_hand(hand_type)
    local hand = G.GAME.hands[hand_type]
    if not hand then return end

    hand.level = hand.level + 1
    hand.chips = hand.chips + hand.l_chips
    hand.mult = hand.mult + hand.l_mult
end

local function sim_planet(consumable)
    local hand_type = consumable.ability.consumeable.hand_type

    if hand_type then
        level_hand(hand_type)
    end
end

local function sim_handler(state)
    local handler = CONSUMABLE_HANDLERS[state.key]

    if handler then
        handler(state)
    elseif state.consumable.ability.set == "Planet" then
        sim_planet(state.consumable)
    end

    if state.key ~= "c_fool"
       and (state.consumable.ability.set == "Tarot"
            or state.consumable.ability.set == "Planet") then
        state.prev_key = state.key
        state.prev_consumable = state.consumable
    end
end

CONSUMABLE_HANDLERS.c_fool = function(state)
    if not state.prev_key or not state.prev_consumable then return end

    state.key = state.prev_key
    state.consumable = state.prev_consumable

    sim_handler(state)
end

CONSUMABLE_HANDLERS.c_black_hole = function(state)
    for hand_type in pairs(G.GAME.hands) do
        level_hand(hand_type)
    end
end

function BALALADLE.CORE.CONSUMABLES.sim_consumables(winning_hand, other_cards)
    local all_cards = misc_utils.merge(winning_hand, other_cards)
    local consumables = misc_utils.shuffle(G.consumeables.cards, "consumables")

    local state = {
        key = nil,
        consumable = nil,
        winning_hand = winning_hand,
        other_cards = other_cards,
        all_cards = all_cards,
        temp_cards = {},
        prev_key = nil,
        prev_consumable = nil,
    }

    for _, consumable in ipairs(consumables) do
        state.key = consumable.config.center.key
        state.consumable = consumable

        sim_handler(state)
    end

    return state
end