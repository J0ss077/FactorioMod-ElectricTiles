-- Tile searches over a surface, plus the full-surface recalculation. The deep
-- variants also report tiles hidden under another tile: those results are plain
-- descriptions carrying the hidden layer's marker, not LuaTile objects.

local caching_controller = require("scripts.controller.cache-controller")

local geometry = require("__factory077-lib__.modules.geometry")

local tables = require("__factory077-lib__.modules.tables")

local temp_storage = require("scripts.var.temp-storage")

local module = {}

--// internals

--- Visits every hidden tile layer whose name is listed in the filter. The
--- visitor returns true to stop the scan.
---
--- @param surface LuaSurface
---
--- @param filter TileSearchFilters
---
--- @param visit fun(name: string, position: MapPosition, marker: string): boolean?
---
local function for_each_hidden_tile(surface, filter, visit)
    --
    local names = tables.to_set(filter.name or {}, true)

    local search = { area = filter.area, has_hidden_tile = true }

    for i0, tile in ipairs(surface.find_tiles_filtered(search)) do
        --
        if tile.hidden_tile and names[tile.hidden_tile] then
            --
            if visit(tile.hidden_tile, tile.position, "F077ET-isSingleHidden") then return end
        end

        if tile.double_hidden_tile and names[tile.double_hidden_tile] then
            --
            if visit(tile.double_hidden_tile, tile.position, "F077ET-isDoubleHidden") then return end
        end
    end
end

--- Caches the chunk that starts at `area` when it holds at least one allowed
--- tile. The deep search is what sees tiles hidden under other tiles.
---
--- @param surface LuaSurface
---
--- @param area BoundingBox
---
--- @param chunk_size integer
---
--- @param allowed_names (string)[]
---
local function cache_populated_chunk(surface, area, chunk_size, allowed_names)
    --
    local count = module.count_tiles_filtered(surface, { name = allowed_names, area = area, limit = 1 }, true)
    --
    if count == 0 then return end
    --
    caching_controller.cache_chunk("base", surface.name, geometry.chunk_position({ x = area[1][1], y = area[1][2] }, chunk_size))
end

--// module functions

--- Returns the visible tiles that match the filter. With `deep`, it also appends
--- the allowed tiles hidden under another tile, one entry per hidden layer.
---
--- @param surface LuaSurface
---
--- @param filter TileSearchFilters
---
--- @param deep? boolean
---
--- @return (LuaTile | table)[]
---
function module.find_tiles_filtered(surface, filter, deep)
    --
    local tiles = surface.find_tiles_filtered(filter)
    --
    if not deep then return tiles end

    for_each_hidden_tile(surface, filter, function (name, position, marker)
        --
        tiles[#tiles + 1] = { name = name, position = position, [marker] = true }
        --
    end)

    return tiles
end

--- Counts the visible tiles that match the filter, plus the allowed hidden ones
--- when `deep` is set. `filter.limit` caps the total, as the engine caps the
--- shallow count.
---
--- @param surface LuaSurface
---
--- @param filter TileSearchFilters
---
--- @param deep? boolean
---
--- @return integer
---
function module.count_tiles_filtered(surface, filter, deep)

    local count = surface.count_tiles_filtered(filter)
    --
    if not deep then return count end
    --
    local limit = filter.limit

    -- The shallow count can already sit at the cap; scanning then would only
    -- push the total past it, which the engine's own limit never does.
    if limit ~= nil and count >= limit then return count end

    for_each_hidden_tile(surface, filter, function ()
        --
        count = count + 1; return limit ~= nil and count >= limit
        --
    end)

    return count
end

--- Recalculates one surface: caches every generated sub-chunk that contains an
--- allowed tile, visible or hidden.
---
--- @param surface LuaSurface
---
function module.recalculate_surface(surface)
    --
    local chunk_size = temp_storage.chunk_area_size

    -- The engine chunk is 32 tiles wide, so it holds chunk_part cached chunks
    -- along each axis: 1 at x32, 2 at x16, 4 at x8.
    local chunk_part = 32 / chunk_size

    local allowed_names = temp_storage.list_allowed_tiles

    for chunk in surface.get_chunks() do
        --
        if surface.is_chunk_generated(chunk) then
            --
            for offset_x = 0, chunk_part - 1 do
                --
                for offset_y = 0, chunk_part - 1 do
                    --
                    local left_top = {
                        (32 * chunk.x) + (offset_x * chunk_size),
                        (32 * chunk.y) + (offset_y * chunk_size),
                    }

                    local area = { left_top, { left_top[1] + chunk_size, left_top[2] + chunk_size } }

                    cache_populated_chunk(surface, area, chunk_size, allowed_names)
                end
            end
        end
    end
end

return module
