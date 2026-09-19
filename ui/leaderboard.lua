local HEIGHT = 10.425
local WIDTH = 4
local BORDER = 0.14

local NON_ENTRIES_SIZE = 3
local LEADERBOARD_END_GAP = 2
local LEADERBOARD_SIZE = 10

local RANK_COLORS = {
    [1] = G.C.DARK_EDITION,
    [2] = darken(G.C.GOLD, 0.1),
    [3] = darken(G.C.ORANGE, 0.5)
}

local function create_leaderboard_skeleton()
    return {
        n = G.UIT.C,
        config = {
            align = "cm",
            minh = HEIGHT,
            minw = WIDTH,
            maxw = WIDTH,
            r = 0.3,
            colour = G.C.EDITION,
            emboss = 0.1,
        },
        nodes = {{
            n = G.UIT.C,
            config = {
                align = "tm",
                minh = HEIGHT - BORDER,
                minw = WIDTH - BORDER,
                r = 0.2,
                colour = G.C.BLACK,
            },
            nodes = {
                {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={

                    {n=G.UIT.O, config={
                            object = DynaText({
                                string = {localize('ph_impy_leaderboard')},
                                colours = {G.C.EDITION},
                                shadow = true, rotate = true,
                                scale = 0.6, spacing = 1,
                            })
                        }
                    },
                }},

                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={
                            object = DynaText({
                                string = {localize('ph_impy_percent_diff')},
                                colours = {G.C.JOKER_GREY},
                                shadow = true,
                                scale = 0.25, spacing = 1,
                            })
                        }
                    },
                }},

                -- Padding bottom
                {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={}},
            }
        }}
    }
end

local function create_leaderboard_entry_skeleton(rank, rank_color)
    local chip_sprite = Sprite(
        0, 0, 0.2, 0.2,
        G.ASSET_ATLAS["ui_"..(G.SETTINGS.colourblind_option and 2 or 1)],
        {x=0, y=0}
    )
    chip_sprite.states.drag.can = false

    local score_tab = {
        {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={w=0.2, h=0.2, object = chip_sprite}}
            }
        },
        {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={
                    object = DynaText({
                        string = {"..."},
                        colours = {G.C.RED},
                        shadow = true, float = true,
                        scale = 0.4,
                    })
                }},
            }
        },
    }

    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.05,
            r = 0.1,
            colour = rank_color or darken(G.C.JOKER_GREY, 0.1),
            minw = 3.5,
            maxw = 3.5,
            emboss = 0.05,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.02,
                    minw = 2.1,
                    maxw = 2.1,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = tostring(rank) .. ". " .. "Loading...",
                            scale = 0.35,
                            colour = G.C.UI.TEXT_LIGHT,
                            shadow = true,
                        },
                    },
                },
            },

            {
                n = G.UIT.C,
                config = {
                    align = "cr",
                },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            align = "cm",
                            minh = 0.5,
                            minw = 1.2,
                            r = 0.1,
                            colour = G.C.BLACK,
                            emboss = 0.05,
                        },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = {
                                    align = "cm",
                                    padding = 0.05,
                                    r = 0.1,
                                    minw = 1.2,
                                },
                                nodes = score_tab,
                            },
                        }
                    },
                }
            },
        },
    }
end

local function fill_leaderboard_skeleton(leaderboard)
    local leaderboard_nodes = leaderboard.nodes[1].nodes

    for i = 1, 10 do
        leaderboard_nodes[#leaderboard_nodes + 1] =
            create_leaderboard_entry_skeleton(i, RANK_COLORS[i] or nil)
    end

    leaderboard_nodes[#leaderboard_nodes + 1] =
        {n=G.UIT.R, config={align = "cm", padding = 0.12}, nodes={
            {n=G.UIT.O, config={
                    object = DynaText({
                        string = {"..."},
                        colours = {G.C.EDITION},
                        shadow = true, rotate = true,
                        scale = 1, spacing = 10,
                    })
                }
            },
        }}

    leaderboard_nodes[#leaderboard_nodes + 1] =
        create_leaderboard_entry_skeleton(LEADERBOARD_SIZE + 1)

    return leaderboard
end

local function fill_leaderboard_rank_entry(leaderboard, rank, username, score)
    local leaderboard_nodes = leaderboard.nodes[1].nodes
    local entry = leaderboard_nodes[rank + NON_ENTRIES_SIZE]

    local username_node = entry.nodes[1].nodes[1]
    username_node.config.text = tostring(rank) .. ". " .. tostring(username)

    local score_text = entry.nodes[2].nodes[1].nodes[1].nodes[2].nodes[1]
        .config.object
    score_text.config.string = { BALALADLE.UTILS.UI.format_score(score) }

    score_text:update_text(true)
    score_text.ui_object_updated = true
end

local function fill_leaderboard_player_entry(leaderboard, rank, score)
    local leaderboard_nodes = leaderboard.nodes[1].nodes
    local entry = leaderboard_nodes[
        LEADERBOARD_SIZE + NON_ENTRIES_SIZE + LEADERBOARD_END_GAP
    ]

    entry.config.colour = RANK_COLORS[rank] or darken(G.C.JOKER_GREY, 0.1)

    local username_node = entry.nodes[1].nodes[1]
    username_node.config.text = tostring(rank) .. ". YOU"

    local score_text = entry.nodes[2].nodes[1].nodes[1].nodes[2].nodes[1]
        .config.object
    score_text.config.string = { BALALADLE.UTILS.UI.format_score(score) }

    score_text:update_text(true)
    score_text.ui_object_updated = true
end

local function hide_leaderboard_rank_entry(leaderboard, rank)
    local leaderboard_nodes = leaderboard.nodes[1].nodes

    leaderboard_nodes[rank + NON_ENTRIES_SIZE] = {
        n = G.UIT.R,
        config = { align = "cm", minh = 0.7, minw = 3.5, maxw = 3.5 },
        nodes = {},
    }
end

local function create_leaderboard_error_line(line)
    return {n=G.UIT.R, config={align = "cm", padding = 0.12}, nodes={
        {n=G.UIT.O, config={
                object = DynaText({
                    string = {line},
                    colours = {G.C.EDITION},
                    shadow = true, rotate = true,
                    scale = 0.4, spacing = 1,
                })
            }
        },
    }}
end

if not BALALADLE.UI.create_UIBox_balaladle_leaderboard then
    function BALALADLE.UI.create_UIBox_balaladle_leaderboard()
        local leaderboard = create_leaderboard_skeleton()
        leaderboard = fill_leaderboard_skeleton(leaderboard)

        return leaderboard
    end

    function BALALADLE.UI.fill_leaderboard(leaderboard, res)
        local entries = res.leaderboard
        local player_rank = res and res.player.rank or nil
        local player_score = res and res.player.score or nil

        for i, entry in ipairs(entries) do
            fill_leaderboard_rank_entry(
                leaderboard, i, entry.username, entry.best_score
            )
        end

        for i = #entries + 1, LEADERBOARD_SIZE do
            hide_leaderboard_rank_entry(leaderboard, i)
        end

        if player_rank and player_score then
            fill_leaderboard_player_entry(
                leaderboard, player_rank, player_score
            )
        end
    end

    function BALALADLE.UI.fill_leaderboard_error(leaderboard, error)
        BALALADLE.UI.clear_leaderboard(leaderboard)

        local leaderboard_nodes = leaderboard.nodes[1].nodes
        local lines = BALALADLE.UTILS.UI.wrap_text(error, 18)

        for i = 1, #lines do
            leaderboard_nodes[#leaderboard_nodes + 1] =
                create_leaderboard_error_line(lines[i])
        end
    end

    function BALALADLE.UI.clear_leaderboard(leaderboard)
        local leaderboard_nodes = leaderboard.nodes[1].nodes

        for i = #leaderboard_nodes, NON_ENTRIES_SIZE + 1, -1 do
            table.remove(leaderboard_nodes, i)
        end
    end

    function BALALADLE.UI.set_leaderboard(leaderboard)
        BALALADLE.UI.leaderboard = leaderboard
    end

    function BALALADLE.UI.get_leaderboard()
        return BALALADLE.UI.leaderboard
    end
end