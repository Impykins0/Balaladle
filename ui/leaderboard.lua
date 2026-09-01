local HEIGHT = 10.425
local WIDTH = 4
local BORDER = 0.14

local function create_leaderboard_entry(rank, username, score, rank_color)
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
                        string = {number_format(score)},
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
                            text = tostring(rank) .. ". " .. tostring(username),
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

local function fill_leaderboard(skeleton, player_score)
    local leaderboard_nodes = skeleton.nodes[1].nodes
    player_score = player_score or 1000

    leaderboard_nodes[#leaderboard_nodes + 1] =
        create_leaderboard_entry(1, "DrSpectred", 0.52, G.C.DARK_EDITION)

    leaderboard_nodes[#leaderboard_nodes + 1] =
        create_leaderboard_entry(2, "Bean", 1.35, darken(G.C.GOLD, 0.1))

    leaderboard_nodes[#leaderboard_nodes + 1] =
        create_leaderboard_entry(3, "Impykins", 2.77, darken(G.C.ORANGE, 0.5))

    for i = 4, 10 do
        leaderboard_nodes[#leaderboard_nodes + 1] =
            create_leaderboard_entry(i, "User " .. tostring(i), i)
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
        create_leaderboard_entry("???", "YOU", player_score)

    return skeleton
end

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

if not BALALADLE.UI.create_UIBox_balaladle_leaderboard then
    function BALALADLE.UI.create_UIBox_balaladle_leaderboard()
        local player_score = BALALADLE.CORE.SCORE.player_score
        local skeleton = create_leaderboard_skeleton()
        local leaderboard = fill_leaderboard(skeleton, player_score)

        return leaderboard
    end
end