local file_paths = {
    "src/balaladle/challenge",
    "src/balaladle/rules",
    "ui/play_button"
}

for _, file_path in ipairs(file_paths) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end