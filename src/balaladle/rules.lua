-- Skip directly to the boss blind + one ante only
local start = Game.start_run
function Game:start_run(args)
    start(self, args)

    G.E_MANAGER:add_event(Event({
        func = function()
            if G.GAME and G.GAME.modifiers.impy_single_blind then
                G.GAME.round_resets.blind_states.Small = "Skipped"
                G.GAME.round_resets.blind_states.Big = "Skipped"
            end

            if G.GAME and G.GAME.modifiers.impy_single_ante then
                G.GAME.win_ante = 1
            end

            return true
        end,
    }))
end