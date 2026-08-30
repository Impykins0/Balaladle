BALALADLE.CORE.DECK = BALALADLE.CORE.DECK or {}
local misc_utils = BALALADLE.UTILS.MISC

local SUITS = {
    "C", 
    "D", 
    "H", 
    "S"
}

local RANKS = {
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

local ENHANCEMENTS = {
    -- "m_stone",
    "m_steel",
    "m_glass",
    "m_gold",
    "m_bonus",
    "m_mult",
    -- "m_wild",
    false,
}

local EDITIONS = {
    "foil",
    "holo",
    "polychrome",
    false,
}

local SEALS = {
    "Red",
    "Gold",
    false,
}

local HAND_COMPAT = {
    ["High Card"] = {
        "Pair",
        "Two Pair",
        "Three of a Kind",
        "Straight",
        "Flush",
        "Full House",
        "Four of a Kind",
        "Straight Flush",
        "Five of a Kind",
        "Flush House",
        "Flush Five",
    },

    ["Pair"] = {
        "High Card",
        "Two Pair",
        "Three of a Kind",
        "Straight",
        "Flush",
        "Full House",
        "Four of a Kind",
        "Straight Flush",
        "Five of a Kind",
        "Flush House",
        "Flush Five",
    },

    ["Three of a Kind"] = {
        "High Card",
        "Pair",
        "Two Pair",
        "Straight",
        "Flush",
        "Full House",
        "Four of a Kind",
        "Straight Flush",
        "Five of a Kind",
        "Flush House",
        "Flush Five",
    },

    ["Two Pair"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Four of a Kind",
    },

    ["Four of a Kind"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Four of a Kind",
        "Five of a Kind",
        "Flush Five",
    },

    ["Flush"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Straight Flush",
        "Flush House",
        "Flush Five",
    },

    ["Straight"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Straight Flush",
    },

    ["Full House"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Flush House",
    },

    ["Straight Flush"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Flush",
        "Straight",
    },

    ["Five of a Kind"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Four of a Kind",
        "Flush Five",
    },

    ["Flush House"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Flush",
        "Full House",
    },

    ["Flush Five"] = {
        "High Card",
        "Pair",
        "Three of a Kind",
        "Four of a Kind",
        "Five of a Kind",
        "Flush",
    },
}

local HAND_OVERLAP = {
    ["Flush"] = {
        "Straight Flush",
        "Flush House",
        "Flush Five",
    },

    ["Straight"] = {
        "Straight Flush",
    },

    ["Full House"] = {
        "Flush House",
    },

    ["Four of a Kind"] = {
        "Five of a Kind",
        "Flush Five",
    },

    ["Five of a Kind"] = {
        "Four of a Kind",
        "Flush Five",
    },

    ["Straight Flush"] = {
        "Flush",
        "Straight",
    },

    ["Flush House"] = {
        "Flush",
        "Full House",
    },

    ["Flush Five"] = {
        "Four of a Kind",
        "Five of a Kind",
        "Flush",
    },
}

local HAND_REQ = {
    ["High Card"] = {
        struct = {1},
    },

    ["Pair"] = {
        struct = {2},
    },

    ["Two Pair"] = {
        struct = {2, 2},
    },

    ["Three of a Kind"] = {
        struct = {3},
    },

    ["Straight"] = {
        straight = true,
    },

    ["Flush"] = {
        flush = true,
    },

    ["Full House"] = {
        struct = {3, 2},
    },

    ["Four of a Kind"] = {
        struct = {4},
    },

    ["Straight Flush"] = {
        straight = true,
        flush = true,
    },

    ["Five of a Kind"] = {
        struct = {5},
    },

    ["Flush House"] = {
        struct = {3, 2},
        flush = true,
    },

    ["Flush Five"] = {
        struct = {5},
        flush = true,
    },
}

local HAND_STRENGTH = {
    ["High Card"]       = 1,
    ["Pair"]            = 2,
    ["Two Pair"]        = 3,
    ["Three of a Kind"] = 4,
    ["Straight"]        = 5,
    ["Flush"]           = 6,
    ["Full House"]      = 7,
    ["Four of a Kind"]  = 8,
    ["Straight Flush"]  = 9,
    ["Five of a Kind"]  = 10,
    ["Flush House"]     = 11,
    ["Flush Five"]      = 12,
}

local function generate_hand_types()
    local winning_hand_type = misc_utils.random_select(
        misc_utils.get_keys(HAND_COMPAT), "hand_type"
    )
    local herring_hand_type = misc_utils.random_select(
        HAND_COMPAT[winning_hand_type], "hand_type"
    )
    return winning_hand_type, herring_hand_type
end

local function order_hands(hand_type_a, hand_type_b)
    local strength_a = HAND_STRENGTH[hand_type_a]
    local strength_b = HAND_STRENGTH[hand_type_b]

    if strength_a < strength_b then
        return hand_type_a, hand_type_b
    end

    return hand_type_b, hand_type_a
end

local function add_card_to_deck(deck, card, winning)
    if card then
        card.impy_winning = winning
        deck[#deck + 1] = card
    end
end

local function add_hand_to_deck(deck, hand, winning)
    for _, card in ipairs(hand) do
        add_card_to_deck(deck, card, winning)
    end
end

local function generate_card(args)
    args = args or {}

    return {
        s = args.s or misc_utils.random_select(SUITS, "suit"),
        r = args.r or misc_utils.random_select(RANKS, "rank"),
        e = misc_utils.random_select(ENHANCEMENTS, "enhancement") or nil,
        d = misc_utils.random_select(EDITIONS, "edition") or nil,
        g = misc_utils.random_select(SEALS, "seal") or nil,
    }
end

local function generate_hand(args)
    local hand = {}

    local suit = nil
    if args.flush then
        suit = misc_utils.random_select(SUITS, "flush_suit")
    end

    if args.straight then
        local start = math.random(5, 10)
        local step = math.random(0, 1) == 0 and -1 or 1

        for i = 1, 5 do
            hand[#hand + 1] = generate_card({
                s = suit,
                r = RANKS[start + ((i - 1) * step)],
            })
        end

        return hand
    end

    if args.struct then
        local used_ranks = {}

        for _, size in ipairs(args.struct) do
            local rank = misc_utils.random_select(RANKS, "straight_rank")

            while misc_utils.contains(used_ranks, rank) do
                rank = misc_utils.random_select(RANKS, "non_used_rank")
            end

            for _ = 1, size do
                hand[#hand + 1] = generate_card({
                    s = suit,
                    r = rank
                })
            end

            used_ranks[#used_ranks + 1] = rank
        end
    else
        for _ = 1, 5 do
            hand[#hand + 1] = generate_card({
                s = suit,
            })
        end
    end

    return hand
end

local function handle_overlap(
    deck, hand, weak_hand_type, strong_hand_type, winning_type
)
    local extra_card = nil

    if weak_hand_type == "Flush" then
        local used_ranks = {}

        for _, card in ipairs(hand) do
            used_ranks[#used_ranks + 1] = card.r
        end

        extra_card = generate_card({
            s = hand[1].s,
            r = misc_utils.random_select_exclude(
                RANKS, used_ranks, "extra_rank"
            ),
        })
    elseif weak_hand_type == "Straight" or weak_hand_type == "Full House"
        or weak_hand_type == "Five of a Kind" then
        extra_card = generate_card({
            s = misc_utils.random_select_exclude(
                SUITS, { hand[1].s }, "extra_suit"
            ),
            r = hand[1].r,
        })
    end

    local is_winning = strong_hand_type == winning_type

    for i, card in ipairs(hand) do
        add_card_to_deck(deck, card, is_winning or i <= 4)
    end

    add_card_to_deck(deck, extra_card, not is_winning)
end

local function generate_deck(winning_hand_type, herring_hand_type, size)
    if not misc_utils.contains(
        HAND_COMPAT[winning_hand_type], herring_hand_type
    ) then
        return {}
    end

    local deck = {}

    if misc_utils.contains(
        HAND_OVERLAP[winning_hand_type], herring_hand_type
    ) then
        local weak_hand_type, strong_hand_type = order_hands(
            winning_hand_type,
            herring_hand_type
        )

        local hand = generate_hand(HAND_REQ[strong_hand_type])

        handle_overlap(
            deck, hand, weak_hand_type, strong_hand_type, winning_hand_type
        )
    else
        local wh = generate_hand(HAND_REQ[winning_hand_type])
        local hh = generate_hand(HAND_REQ[herring_hand_type])
        add_hand_to_deck(deck, wh, true)
        add_hand_to_deck(deck, hh, false)
    end

    while #deck < size do
        local card = generate_card()
        add_card_to_deck(deck, card, false)
    end

    return deck
end

if not BALALADLE.CORE.DECK.starter_deck then
    function BALALADLE.CORE.DECK.starter_deck(size)
        if not BALALADLE.CORE.DECK.deck then
            local wh_type, hh_type = generate_hand_types()
            sendDebugMessage(wh_type .. " + " .. hh_type, "BALALADLE")
            BALALADLE.CORE.DECK.deck = generate_deck(wh_type, hh_type, size)
        end

        return BALALADLE.CORE.DECK.deck
    end

    -- function BALALADLE.CORE.DECK.set_editions_and_seals()
    --     for _, card in ipairs(G.playing_cards) do
    --         local rand_ed = misc_utils.random_select(EDITIONS, "edition")
    --         local rand_seal = misc_utils.random_select(SEALS, "seal")

    --         if rand_ed then
    --             card:set_edition(rand_ed, true, true)
    --         end
    --         if rand_seal then
    --             card:set_seal(rand_seal, true, true)
    --         end
    --     end
    -- end

    function BALALADLE.CORE.DECK.get_winning_hand()
        local winning_hand = {}

        for _, card in ipairs(G.playing_cards) do
            if card.params.impy_winning then
                winning_hand[#winning_hand + 1] = card
            end
        end

        return winning_hand
    end

    function BALALADLE.CORE.DECK.get_other_cards()
        local other_cards = {}

        for _, card in ipairs(G.playing_cards) do
            if not card.params.impy_winning then
                other_cards[#other_cards + 1] = card
            end
        end

        return other_cards
    end
end