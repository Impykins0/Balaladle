local function create_attempt_score_field()
    local chip_sprite = Sprite(
        0, 0, 0.3, 0.3,
        G.ASSET_ATLAS["ui_"..(G.SETTINGS.colourblind_option and 2 or 1)],
        {x=0, y=0}
    )
    chip_sprite.states.drag.can = false

    local score_tab = {
        {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={w=0.3, h=0.3, object = chip_sprite}}
            }
        },
        {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={
                    object = DynaText({
                        string = {BALALADLE.UTILS.UI.format_score(
                            BALALADLE.CORE.SCORE.player_score
                        )},
                        colours = {G.C.RED},
                        shadow = true, float = true,
                        scale = 0.6,
                    })
                }},
            }
        },
    }

    return {
        n=G.UIT.R, 
        config={
            align = "cm",
            padding = 0.05,
            r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1),
            emboss = 0.05,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.02,
                    minw = 3.5,
                    maxw = 3.5
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = localize("b_impy_attempt_score"),
                            scale = 0.5,
                            colour = G.C.UI.TEXT_LIGHT,
                            shadow = true
                        }
                    },
                }
            },
            {
                n = G.UIT.C,
                config = {align = "cr"},
                nodes = {
                    {
                        n=G.UIT.C, 
                        config = {
                            align = "cm",
                            minh = 0.5,
                            r = 0.1,
                            minw = 3.5,
                            colour = G.C.BLACK,
                            emboss = 0.05
                        },
                        nodes = {
                            {
                                n = G.UIT.C, 
                                config = {
                                    align = "cm",
                                    padding = 0.05,
                                    r = 0.1,
                                    minw = 3.5
                                },
                                nodes=score_tab
                            },
                        }
                    }
                }
            },
        }
    }
end

local function generate_emojis(score)
    if not score then
        return "⬜⬜⬜⬜⬜⬜"
    elseif score > 1000000 then
        return "🟥🟧🟨🟩🟦🟪"
    elseif score == 0 then
        return "🟪🟪🟪🟪🟪🟪"
    elseif score <= 1 then
        return "🟩🟩🟩🟩🟩🟩"
    elseif score <= 5 then
        return "🟩🟩🟩🟩🟩⬜"
    elseif score <= 10 then
        return "🟩🟩🟩🟩⬜⬜"
    elseif score <= 20 then
        return "🟨🟨🟨⬜⬜⬜"
    elseif score <= 50 then
        return "🟧🟧⬜⬜⬜⬜"
    elseif score <= 100 then
        return "🟥⬜⬜⬜⬜⬜"
    end

    return "⬜⬜⬜⬜⬜⬜"
end

local function generate_clipboard_text(score)
    local score_text = BALALADLE.UTILS.UI.format_score(score)

    return "Balaladle " .. tostring(os.date("!%m-%d-%Y")) .. "\n" ..
           score_text .. "% difference from target score\n\n" ..
           generate_emojis(score)
end

G.FUNCS.impy_share_score = function(e)
    local score = BALALADLE.CORE.SCORE.player_score
    love.system.setClipboardText(generate_clipboard_text(score))

    e.children[1].children[1].config.text =
        localize("b_impy_copied_to_clipboard")

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.02,
        blocking = false,
        func = function()
            if G.OVERLAY_MENU then
                G.OVERLAY_MENU:recalculate()
            end

            return true
        end
    }))
end

if not BALALADLE.UI.create_attempt_score_row then
    function BALALADLE.UI.create_attempt_score_row()
        return create_attempt_score_field()
    end
end
