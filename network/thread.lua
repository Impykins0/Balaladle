return [[
    require("love.filesystem")
    local ok, https = pcall(require, "https")

    local req_channel = love.thread.getChannel("req_channel")
    local res_channel = love.thread.getChannel("res_channel")

    if not ok then
        res_channel:push({
            fatal = true,
            error = "Could not establish connection to the server.",
        })

        return
    end

    while true do
        local req = req_channel:demand()

        local options = {
            method = req.method,
            data = req.body,
            headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = req.body and "application/json" or nil,
            }
        }

        local status, body, headers = https.request(req.url, options)

        if not status or status == 0 then
            res_channel:push({
                id = req.id,
                error = "Network request failed.",
            })
        else
            res_channel:push({
                id = req.id,
                status = status,
                body = body or "",
                headers = headers,
            })
        end
    end
]]