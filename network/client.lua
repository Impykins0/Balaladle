local json = require("json")
local THREAD = assert(SMODS.load_file("network/thread.lua"))()

local DEBUG = true

local function try_call(callback, err, data)
    if callback then
        callback(err == nil, data)
    end

    if DEBUG and err then
        sendDebugMessage(err, "BALALADLE")
    end
end

local function request(method, path, data, callback)
    if not BALALADLE.NETWORK.thread then return end

    if BALALADLE.NETWORK.disabled then
        try_call(callback, "Could not establish connection to the server.")
        return
    end

    BALALADLE.NETWORK.id = BALALADLE.NETWORK.id + 1
    BALALADLE.NETWORK.pending[BALALADLE.NETWORK.id] = callback

    BALALADLE.NETWORK.req_channel:push({
        id = BALALADLE.NETWORK.id,
        method = method,
        url = BALALADLE.NETWORK.base_url .. path,
        body = data and json.encode(data) or nil,
    })
end

if not BALALADLE.NETWORK.init then
    function BALALADLE.NETWORK.init(base_url)
        if BALALADLE.NETWORK.thread then return end

        BALALADLE.NETWORK.req_channel = love.thread.getChannel("req_channel")
        BALALADLE.NETWORK.res_channel = love.thread.getChannel("res_channel")

        BALALADLE.NETWORK.base_url = base_url:gsub("/+$", "")
        BALALADLE.NETWORK.id = 0
        BALALADLE.NETWORK.pending = {}

        BALALADLE.NETWORK.thread = love.thread.newThread(THREAD)
        BALALADLE.NETWORK.thread:start()
    end

    function BALALADLE.NETWORK.get(path, callback)
        request("GET", path, nil, callback)
    end

    function BALALADLE.NETWORK.post(path, data, callback)
        request("POST", path, data, callback)
    end

    function BALALADLE.NETWORK.update()
        while not BALALADLE.NETWORK.disabled do
            local res = BALALADLE.NETWORK.res_channel:pop()
            if not res then break end

            if res.fatal then
                BALALADLE.NETWORK.disabled = true

                local pending = BALALADLE.NETWORK.pending
                BALALADLE.NETWORK.pending = {}

                for _, callback in pairs(pending) do
                    try_call(callback, res.error)
                end
            else
                local callback = BALALADLE.NETWORK.pending[res.id]
                BALALADLE.NETWORK.pending[res.id] = nil

                local err = res.error
                local data = nil

                if not err and res.body ~= "" then
                    local ok, result = pcall(json.decode, res.body)
                    data = result

                    if not ok then
                        err = "Could not process server response."
                        data = nil
                    elseif res.status < 200 or res.status >= 300 then
                        err = "Error: HTTP Status " .. tostring(res.status)
                    end
                end

                try_call(callback, err, data)
            end
        end
    end
end