BALALADLE.CORE.LEADERBOARD = BALALADLE.CORE.LEADERBOARD or {}

local luasteam = require("luasteam")
local player_id = ""
if luasteam.init() then
    player_id = tostring(luasteam.user.getSteamID())
end

if not BALALADLE.CORE.LEADERBOARD.submit then
    function BALALADLE.CORE.LEADERBOARD.submit(score)
        local data = {}
        data.player_id = player_id
        if score ~= nil then
            data.score = score
        end

        BALALADLE.NETWORK.post("/attempts", data, function(ok, status, res)
            if not ok then
                BALALADLE.UI.fill_leaderboard_error(
                    BALALADLE.UI.get_leaderboard(),
                    "Failed to submit Balaladle score."
                )
            else
                sendDebugMessage("Balaladle score submitted!", "BALALADLE")
            end
        end)
    end

    function BALALADLE.CORE.LEADERBOARD.load()
        local data = {}
        data.player_id = player_id

        BALALADLE.NETWORK.post("/leaderboard", data, function(ok, status, res)
            if not ok then
                local err_msg =
                    "Unable to load friends leaderboard. Internal server error."

                if status == 401 then
                    err_msg = "Unable to load friends leaderboard. Steam friends list is currently private."
                elseif status == 404 then
                    err_msg = "Unable to load friends leaderboard. Steam user not found."
                elseif status == 429 then
                    err_msg = "Unable to load friends leaderboard. Too many requests. Please try again later."
                end

                BALALADLE.UI.fill_leaderboard_error(
                    BALALADLE.UI.get_leaderboard(),
                    err_msg
                )
            else
                BALALADLE.UI.fill_leaderboard(
                    BALALADLE.UI.get_leaderboard(),
                    res
                )
            end
        end)
    end
end