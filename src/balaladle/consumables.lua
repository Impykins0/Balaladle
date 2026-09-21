BALALADLE.CORE.CONSUMABLES = BALALADLE.CORE.CONSUMABLES or {}
local misc_utils = BALALADLE.UTILS.MISC

local BANNED_CONSUMABLES = {
    -- Tarots
    "c_magician",
    "c_high_priestess",
    "c_emperor",
    "c_lovers",
    "c_hermit",
    "c_wheel_of_fortune",
    "c_hanged_man",
    "c_judgement",
    "c_tower",

    -- Spectrals
    "c_familiar",
    "c_grim",
    "c_incantation",
    "c_aura",
    "c_wraith",
    "c_sigil",
    "c_ouija",
    "c_ectoplasm",
    "c_immolate",
    "c_ankh",
    "c_hex",
    "c_trance",
    "c_medium",
    "c_soul",
}

local TAROTS = {
    "c_fool",
    "c_empress",
    "c_heirophant",
    "c_chariot",
    "c_justice",
    "c_strength",
    "c_death",
    "c_temperance",
    "c_devil",
    "c_star",
    "c_moon",
    "c_sun",
    "c_world",
}

local PLANETS = {
    "c_mercury",
    "c_venus",
    "c_earth",
    "c_mars",
    "c_jupiter",
    "c_saturn",
    "c_uranus",
    "c_neptune",
    "c_pluto",
    "c_planet_x",
    "c_ceres",
    "c_eris",
}

local SPECTRALS = {
    "c_talisman",
    "c_deja_vu",
    "c_cryptid",
    "c_black_hole",
}

local function generate_banned_consumables()
    local banned = {}

    for _, card_id in pairs(BANNED_CONSUMABLES) do
        banned[#banned + 1] = { id = card_id }
    end

    return banned
end

local function generate_consumables()
    local tarot = { id = misc_utils.random_select(TAROTS, "tarot") }
    local planet = { id = misc_utils.random_select(PLANETS, "planet") }
    local spectral = { id = misc_utils.random_select(SPECTRALS, "spectral") }

    return {tarot, planet, spectral}
end

if not BALALADLE.CORE.CONSUMABLES.get_banned_consumables then
    function BALALADLE.CORE.CONSUMABLES.get_banned_consumables()
        if not BALALADLE.CORE.CONSUMABLES.banned_consumables then
            BALALADLE.CORE.CONSUMABLES.banned_consumables =
                generate_banned_consumables()
        end

        return BALALADLE.CORE.CONSUMABLES.banned_consumables
    end

    function BALALADLE.CORE.CONSUMABLES.get_consumables()
        if not BALALADLE.CORE.CONSUMABLES.consumables then
            BALALADLE.CORE.CONSUMABLES.consumables = generate_consumables()
        end

        return BALALADLE.CORE.CONSUMABLES.consumables
    end
end