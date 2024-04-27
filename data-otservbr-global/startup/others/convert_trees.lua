local trees = {
    [3681] = {3699} -- blueberry bush
    -- [3617] = {50144}, -- plum tree
    -- [3619] = {50146} -- pear tree
}

-- will randomly convert some trees into harvestable ones
function ConvertTrees()
    local i = 0
    for x = 30000, 35000 do
        for y = 30000, 35000 do
            local tile = Tile(Position(x, y, 7))
            if tile then
                for k, v in pairs(trees) do
                    local tree = tile:getItemById(k)
                    if tree and math.random(5) == 1 then
                        tree:transform(v[1])
                        i = i + 1
                    end
                end
            end
        end
    end
    Spdlog.info("Successfully converted " .. i .. " trees")
end
