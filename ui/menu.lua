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
    if MP then
        MP.LOBBY.config.ruleset = nil
        MP.LOBBY.config.gamemode = nil
        MP.SP.ruleset = nil
        MP.SP.practice = false
        MP.GHOST.clear()
    end

    G.FUNCS.start_challenge_run({
        config = {
            id = ui_utils.get_challenge_index("c_impy_daily_1"),
        },
    })
end

local function create_mp_ui()
    local ui_ref = G.UIDEF.override_main_menu_play_button

    function G.UIDEF.override_main_menu_play_button()
        local ui = ui_ref()

        if not G.SETTINGS.tutorial_complete
           or G.SETTINGS.tutorial_progress ~= nil then
            return ui
        end

        local buttons = ui.nodes[1].nodes[1].nodes[1].nodes

        for i, button in ipairs(buttons) do
            local button_config =
                button.nodes
                and button.nodes[1]
                and button.nodes[1].config

            if button_config
               and button_config.button == "start_vanilla_sp" then
                table.insert(buttons, i + 1, UIBox_button({
                    label = { localize("b_impy_daily_1") },
                    colour = G.C.RED,
                    button = "daily_start_1",
                    minw = 5,
                }))

                break
            end
        end

        return ui
    end
end

local function create_non_mp_ui()

end

local function check_for_multiplayer()
    if not SMODS.Mods["Multiplayer"]
       or not SMODS.Mods["Multiplayer"].can_load then
        sendDebugMessage("Multiplayer compatibility not detected", "BALALADLE")
        create_non_mp_ui()

        return true
    end

    sendDebugMessage("Multiplayer compatibility detected", "BALALADLE")
    create_mp_ui()

    return true
end

G.E_MANAGER:add_event(Event({
    trigger = "immediate",
    func = check_for_multiplayer,
}))