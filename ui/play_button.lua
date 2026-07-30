local ui_utils = assert(SMODS.load_file("src/utils/ui.lua"))()

G.FUNCS.daily_start_1 = function(e)
    G.FUNCS.exit_overlay_menu()

    G.FUNCS.start_challenge_run({
        config = {
            id = ui_utils.get_challenge_index("c_impy_daily_1"),
        },
    })
end

if SMODS.Mods["Multiplayer"] and SMODS.Mods["Multiplayer"].can_load
   and G.UIDEF.override_main_menu_play_button and G.FUNCS.play_options then
    sendDebugMessage("Multiplayer compatibility detected", "BALALADLE")

    local ref = G.UIDEF.override_main_menu_play_button
    function G.UIDEF.override_main_menu_play_button()
        local ui = ref()

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