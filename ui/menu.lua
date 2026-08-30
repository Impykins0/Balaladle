local ui_utils = BALALADLE.UTILS.UI
local daily_utils = BALALADLE.UTILS.DAILY

local challenge_ref = G.FUNCS.start_challenge_run
G.FUNCS.start_challenge_run = function(e)
    local id = ui_utils.get_challenge_index("c_impy_daily_1")

    if e.config.id == id then
        if G.OVERLAY_MENU then
            G.FUNCS.exit_overlay_menu()
        end

        G.FUNCS.start_run(e, {
            stake = 1,
            seed = daily_utils.get_seed(),
            challenge = G.CHALLENGES[id],
        })

        return
    end

    challenge_ref(e)
end

G.FUNCS.daily_start_1 = function(e)
    G.FUNCS.start_challenge_run({
        config = {
            id = ui_utils.get_challenge_index("c_impy_daily_1"),
        },
    })
end

if SMODS.Mods["Multiplayer"] and SMODS.Mods["Multiplayer"].can_load
   and G.UIDEF.override_main_menu_play_button and G.FUNCS.play_options then
    sendDebugMessage("Multiplayer compatibility detected", "BALALADLE")

    local ui_ref = G.UIDEF.override_main_menu_play_button
    function G.UIDEF.override_main_menu_play_button()
        local ui = ui_ref()

        if not G.SETTINGS.tutorial_complete
           or G.SETTINGS.tutorial_progress ~= nil then
            return ui
        end

        local buttons = ui.nodes[1].nodes[1].nodes[1].nodes
        for i, button in ipairs(buttons) do
            if button.nodes
               and button.nodes[1].config.button == "start_vanilla_sp" then
                table.insert(buttons, i + 1,
                    UIBox_button({
                        label = { localize("b_impy_daily_1") },
                        colour = G.C.RED,
                        button = "daily_start_1",
                        minw = 5,
                    })
                )
            end
        end

        return ui
    end
else
    sendDebugMessage("Multiplayer compatibility not detected", "BALALADLE")

    -- TODO: UI that doesn't depend on multiplayer mod
end