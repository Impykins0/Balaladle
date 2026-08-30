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
end