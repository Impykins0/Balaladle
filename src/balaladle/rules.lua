-- Skip directly to the boss blind
local start = Game.start_run
function Game:start_run(args)
    start(self, args)

    G.E_MANAGER:add_event(Event({
        func = function()
            if G.GAME and G.GAME.modifiers.impy_single_blind then
                G.GAME.round_resets.blind_states.Small = "Skipped"
                G.GAME.round_resets.blind_states.Big = "Skipped"

                return true
            end
        end,
    }))
end