local M = {}

function M.get_challenge_index(id)
    for i, challenge in ipairs(G.CHALLENGES) do
        if challenge.id == id then
            return i
        end
    end

    return nil
end

return M