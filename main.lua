local file_paths = {
    "src/challenges/daily",
    "ui/play_button"
}

for _, file_path in ipairs(file_paths) do
    assert(SMODS.load_file(file_path .. ".lua"))()
end