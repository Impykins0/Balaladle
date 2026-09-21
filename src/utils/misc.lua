BALALADLE.UTILS.MISC = BALALADLE.UTILS.MISC or {}
local daily_utils = BALALADLE.UTILS.DAILY

local counter = 0

if not BALALADLE.UTILS.MISC.random_select then
    function BALALADLE.UTILS.MISC.random_select(table, key)
        if table == nil or #table == 0 then
            return nil
        end

        counter = counter + 1

        return pseudorandom_element(
            table,
            pseudoseed(
                "impy_" .. key .. "_" .. tostring(counter),
                daily_utils.get_seed()
            )
        )
    end

    function BALALADLE.UTILS.MISC.shuffle(table, key)
        if table == nil or #table <= 1 then
            return table
        end

        local shuffled = {}

        for _, v in pairs(table) do
            shuffled[#shuffled + 1] = v
        end

        counter = counter + 1

        pseudoshuffle(
            shuffled,
            pseudoseed(
                "impy_" .. key .. "_" .. tostring(counter),
                daily_utils.get_seed()
            )
        )

        return shuffled
    end

    function BALALADLE.UTILS.MISC.get_keys(dict)
        local keys = {}

        for key, _ in pairs(dict) do
            keys[#keys + 1] = key
        end

        return keys
    end

    function BALALADLE.UTILS.MISC.contains(table, value)
        if table == nil or #table == 0 then
            return false
        end

        for _, v in pairs(table) do
            if v == value then
                return true
            end
        end

        return false
    end

    function BALALADLE.UTILS.MISC.slice(table, start, stop)
        local sliced = {}

        for i = start, stop do
            sliced[#sliced + 1] = table[i]
        end

        return sliced
    end

    function BALALADLE.UTILS.MISC.random_select_exclude(table, excluded, key)
        if excluded == nil or #excluded == 0 then
            return BALALADLE.UTILS.MISC.random_select(table, key)
        end

        if #excluded >= #table then
            return nil
        end

        local available = {}

        for _, v in pairs(table) do
            if not BALALADLE.UTILS.MISC.contains(excluded, v) then
                available[#available + 1] = v
            end
        end

        return BALALADLE.UTILS.MISC.random_select(available, key)
    end

    function BALALADLE.UTILS.MISC.random_select_multi(table, amount, key)
        if amount < 1 then
            return {}
        elseif amount == 1 then
            return { BALALADLE.UTILS.MISC.random_select(table, key) }
        end

        local shuffled = BALALADLE.UTILS.MISC.shuffle(table, key)
        return BALALADLE.UTILS.MISC.slice(shuffled, 1, amount)
    end

    function BALALADLE.UTILS.MISC.merge(table1, table2)
        local result = {}

        for i = 1, #table1 do
            result[#result + 1] = table1[i]
        end

        for i = 1, #table2 do
            result[#result + 1] = table2[i]
        end

        return result
    end
end