local file_paths = {
    "src/balaladle/challenge",
    "src/balaladle/rules",
    "src/balaladle/jokers",
    "ui/play_button"
}

for _, file_path in ipairs(file_paths) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end