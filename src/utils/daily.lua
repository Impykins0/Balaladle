local seed = tonumber(os.date("!%Y%m%d"))

local banned_jokers = {
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
}

local rng_usable_jokers = {
    "j_business",
    "j_bloodstone",
    "j_reserved_parking",
    "j_oops"
}

local hand_usable_jokers = {
    "j_trousers",
    "j_vampire",
    "j_card_sharp",
    "j_green_joker",
    "j_ride_the_bus",
    "j_supernova",
}

local discard_usable_jokers = {
    "j_burnt",
    "j_hit_the_road",
    "j_castle",
    "j_trading",
    "j_mail",
    "j_faceless",
}

local hand_size_usable_jokers = {
    "j_turtle_bean",
    "j_juggler",
}

local card_dependent_usable_jokers = {
    "j_stone",
    "j_glass",
    "j_steel_joker",
}

local M = {}

function M.get_seed()
    return seed
end

function M.get_banned_jokers()
    local banned = {}

    for _, card_id in pairs(banned_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(rng_usable_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(hand_usable_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(discard_usable_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(hand_size_usable_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    for _, card_id in pairs(card_dependent_usable_jokers) do
        banned[#banned + 1] = { id = card_id }
    end

    return banned
end

return M