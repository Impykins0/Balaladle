local ui_utils = BALALADLE.UTILS.UI
local daily_utils = BALALADLE.UTILS.DAILY

local challenge_ref = G.FUNCS.start_challenge_run
G.FUNCS.start_challenge_run = function(e)
    local id = ui_utils.get_challenge_index("c_impy_daily_1")

    if e.config.id == id then
        if G.OVERLAY_MENU then
            G.FUNCS.exit_overlay_menu()
        end

        if MP then
            MP.LOBBY.config.ruleset = nil
            MP.LOBBY.config.gamemode = nil
            MP.SP.ruleset = nil
            MP.SP.practice = false
            MP.GHOST.clear()
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

function G.FUNCS.go_to_balaladle()
    local id = ui_utils.get_challenge_index("c_impy_daily_1")
    G.FUNCS.challenge_list({config = {}})

    local back_button =
        G.OVERLAY_MENU.UIRoot.children[1].children[1].children[2]
    back_button.config.button = "exit_overlay_menu"

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.15,
        func = function()
            local page = math.floor((id - 1) / G.CHALLENGE_PAGE_SIZE) + 1
            local challenge_page =
                G.OVERLAY_MENU:get_UIE_by_ID("challenge_page")
            local cycle = challenge_page.children[1].config.ref_table

            cycle.current_option = page
            cycle.current_option_val = cycle.options[page]

            G.FUNCS.change_challenge_list_page({
                cycle_config = cycle
            })

            local challenge_list =
                G.OVERLAY_MENU:get_UIE_by_ID("challenge_list")
            local challenge_button =
                challenge_list.config.object:get_UIE_by_ID(id)

            if challenge_button then
                G.FUNCS.change_challenge_description(challenge_button)
            end

            return true
        end
    }))
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
                    button = "go_to_balaladle",
                    minw = 5,
                }))

                break
            end
        end

        return ui
    end
end

local function create_non_mp_ui()
    local ui_ref = G.UIDEF.run_setup

    function G.UIDEF.run_setup(from_game_over)
        local ui = ui_ref(from_game_over)

        if not G.SETTINGS.tutorial_complete
            or G.SETTINGS.tutorial_progress ~= nil then
            return ui
        end

        local contents = ui.nodes[1].nodes[1].nodes[1]
        local tabs = contents.nodes[1].nodes[1]
        local tab_buttons = tabs.nodes[1].nodes[2]

        table.insert(tab_buttons.nodes, UIBox_button({
            label = { localize("b_impy_daily_1") },
            colour = G.C.RED,
            button = "go_to_balaladle",
            minw = 2.5,
            minh = 0.8,
            col = true,
            focus_args = {type = "none"},
        }))

        return ui
    end
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