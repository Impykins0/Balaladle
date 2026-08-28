-- The Blank
SMODS.Blind {
    key = "blank",
    dollars = 5,
    mult = 1,
    pos = { x = 0, y = 30 },
    boss = { min = 1 },
    in_pool = function(self)
        return false
    end,
}