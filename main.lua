BALALADLE = BALALADLE or {}
BALALADLE.UTILS = BALALADLE.UTILS or {}
BALALADLE.CORE = BALALADLE.CORE or {}
BALALADLE.UI = BALALADLE.UI or {}

local dependencies = {
    "DVSimulation/src/Init",
    "DVSimulation/src/Utils",
    "DVSimulation/src/Engine",
    "DVSimulation/src/Jokers/_Vanilla",
}

for _, file_path in ipairs(dependencies) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end

local utils = {
    "src/utils/daily",
    "src/utils/ui",
    "src/utils/misc",
}

for _, file_path in ipairs(utils) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end

local modules = {
    "src/balaladle/jokers",
    "src/balaladle/deck",
    "src/balaladle/score",
    "src/balaladle/blind",
    "src/balaladle/challenge",
    "src/balaladle/rules",
    "ui/menu",
    "ui/leaderboard",
}

for _, file_path in ipairs(modules) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end