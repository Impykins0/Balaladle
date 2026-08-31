local daily_score = BALALADLE.CORE.SCORE

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

-- Calculate exact blind score
local blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    blind_ref(self, blind, reset, silent)

    if blind and G.GAME.modifiers.impy_calculated_score then
        local score = daily_score.get_calculated_score()
        self.chips = score
        self.chip_text = number_format(score)
    end
end