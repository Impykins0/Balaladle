if not BALALADLE.NETWORK.is_init then
    BALALADLE.NETWORK.is_init = true
    BALALADLE.NETWORK.init("https://balaladle-server.balaladle.workers.dev")

    local update_ref = Game.update
    function Game:update(dt)
        local result = update_ref(self, dt)

        if BALALADLE.NETWORK.update then
            BALALADLE.NETWORK.update()
        end

        return result
    end
end

-- Test API call
BALALADLE.NETWORK.get("/test", function(ok, data)
    if not ok then
        sendDebugMessage("Test failed", "BALALADLE")
    else
        sendDebugMessage(data.message, "BALALADLE")
    end
end)