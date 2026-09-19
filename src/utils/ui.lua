BALALADLE.UTILS.UI = BALALADLE.UTILS.UI or {}

if not BALALADLE.UTILS.UI.get_challenge_index then
    function BALALADLE.UTILS.UI.get_challenge_index(id)
        for i, challenge in ipairs(G.CHALLENGES) do
            if challenge.id == id then
                return i
            end
        end

        return nil
    end

    function BALALADLE.UTILS.UI.wrap_text(text, max_chars)
        local lines = {}
        local line = ""

        for word in string.gmatch(text, "([^".. "%s" .."]+)") do
            if line == "" then
                line = word
            elseif #line + #word >= max_chars then
                lines[#lines + 1] = line
                line = word
            else
                line = line .. " " .. word
            end
        end

        if line ~= "" then
            lines[#lines + 1] = line
        end

        return lines
    end

    function BALALADLE.UTILS.UI.format_score(score)
        if score < 10 then
            return string.format("%.3f", score)
        elseif score < 100 then
            return string.format("%.2f", score)
        elseif score < 1000 then
            return string.format("%.1f", score)
        elseif score < 10000 then
            return string.format("%.0f", score)
        else
            local exponent = math.floor(math.log(score, 10))
            local coeff = score / (10 ^ exponent)
            coeff = math.floor(coeff + 0.5)

            if coeff >= 10 then
                coeff = coeff / 10
                exponent = exponent + 1
            end

            return string.format("%.1fE%d", coeff, exponent)
        end
    end
end