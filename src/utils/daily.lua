BALALADLE.UTILS.DAILY = BALALADLE.UTILS.DAILY or {}

local seed = tostring(os.date("!%Y%m%d"))

if not BALALADLE.UTILS.DAILY.get_seed then
    function BALALADLE.UTILS.DAILY.get_seed()
        return seed
    end
end