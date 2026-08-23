local dependencies = {
    "DVSimulation/src/Init",
    "DVSimulation/src/Utils",
    "DVSimulation/src/Engine",
    "DVSimulation/src/Jokers/_Vanilla",
}

local native_files = {
    "src/balaladle/blind",
    "src/balaladle/challenge",
    "src/balaladle/rules",
    "ui/play_button"
}

for _, file_path in ipairs(dependencies) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end

for _, file_path in ipairs(native_files) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end