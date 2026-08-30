BALALADLE.CORE.JOKERS = BALALADLE.CORE.JOKERS or {}
local misc_utils = BALALADLE.UTILS.MISC

local EDITIONS = {
    "foil",
    "holo",
    "polychrome",
    false,
}

local BANNED_JOKERS = {
    "j_perkeo",
    "j_chicot",
    "j_astronomer",
    "j_cartomancer",
    "j_satellite",
    "j_invisible",
    "j_matador",
    "j_merry_andy",
    "j_ring_master",
    "j_throwback",
    "j_certificate",
    "j_troubadour",
    "j_mr_bones",
    "j_campfire",
    "j_flash",
    "j_diet_cola",
    "j_lucky_cat",
    "j_golden",
    "j_drunkard",
    "j_hallucination",
    "j_to_the_moon",
    "j_gift",
    "j_luchador",
    "j_rocket",
    "j_cloud_9",
    "j_vagabond",
    "j_shortcut",
    "j_riff_raff",
    "j_seance",
    "j_madness",
    "j_red_card",
    "j_superposition",
    "j_hiker",
    "j_sixth_sense",
    "j_burglar",
    "j_egg",
    "j_space",
    "j_delayed_grat",
    "j_chaos",
    "j_misprint",
    "j_8_ball",
    "j_loyalty_card",
    "j_marble",
    "j_credit_card",
    "j_four_fingers",
    "j_stuntman",
    "j_splash",
}

local RNG_USABLE_JOKERS = {
    "j_business",
    "j_bloodstone",
    "j_reserved_parking",
    "j_oops"
}

local HAND_USABLE_JOKERS = {
    "j_trousers",
    "j_vampire",
    "j_card_sharp",
    "j_green_joker",
    "j_ride_the_bus",
    "j_supernova",
}

local DISCARD_USABLE_JOKERS = {
    "j_burnt",
    "j_hit_the_road",
    "j_castle",
    "j_trading",
    "j_mail",
    "j_faceless",
}

local HAND_SIZE_USABLE_JOKERS = {
    "j_turtle_bean",
    "j_juggler",
}

local CARD_DEPENDENT_USABLE_JOKERS = {
    "j_stone",
    "j_glass",
    "j_steel_joker",
}

local MONEY_DEPENDENT_USABLE_JOKERS = {
    "j_bull",
    "j_bootstraps",
}

local function generate_banned_jokers()
    local banned = {}

    for _, card_id in pairs(BANNED_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(RNG_USABLE_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(HAND_USABLE_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(DISCARD_USABLE_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(HAND_SIZE_USABLE_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(CARD_DEPENDENT_USABLE_JOKERS) do
        banned[#banned + 1] = { id = card_id }
    end

    return banned
end

local function generate_jokers(amount)
    local pool = {}
    local selected = {}
    local banned_table = {}

    local banned_jokers = BALALADLE.CORE.JOKERS.get_banned_jokers()

    for _, card in pairs(banned_jokers) do
        banned_table[card.id] = true
    end

    for _, joker in pairs(G.P_CENTER_POOLS.Joker) do
        if joker.mod or not joker.unlocked or banned_table[joker.key] then
            goto continue
        end

        pool[#pool + 1] = joker.key

        ::continue::
    end

    for _ = 1, math.min(amount, #pool) do
        local edition = misc_utils.random_select(EDITIONS, "joker_edition")

        local joker = {
            id = misc_utils.random_select(pool, "joker"),
            eternal = true,
        }

        if edition then
            joker.edition = edition
        end

        selected[#selected + 1] = joker
    end

    return selected
end

if not BALALADLE.CORE.JOKERS.get_banned_jokers then
    function BALALADLE.CORE.JOKERS.get_banned_jokers()
        if not BALALADLE.CORE.JOKERS.banned_jokers then
            BALALADLE.CORE.JOKERS.banned_jokers = generate_banned_jokers()
        end

        return BALALADLE.CORE.JOKERS.banned_jokers
    end

    function BALALADLE.CORE.JOKERS.get_jokers(amount)
        if not BALALADLE.CORE.JOKERS.jokers and amount then
            BALALADLE.CORE.JOKERS.jokers = generate_jokers(amount)
        end

        return BALALADLE.CORE.JOKERS.jokers
    end
end